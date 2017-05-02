#  Tutorial.tf
# For sake of simplicity, we are putting everything in one file
# Normally, you will break each section into its own file for better
# organization. Each section will include the suggested file name
# to use if one were to break this single file out into parts.

### Variables
### file: variables.tf
### User-defined variables, if any

### Providers
### file:providers.tf
### Credentials for different providers we will use.

provider "aws" {
  # You can delete this entry if you have it defined in ~/.aws/credentials
  # file or if you export AWS_DEFAULT_REGION as environment variable
  region     = "<YOUR REGION HERE>"

  # You can delete these entries if you have ~/.aws/credentials file
  # or you export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  access_key = "<YOUR KEY HERE>"
  secret_key = "<YOUR SECRET HERE>"
}

### Network
### file: network.tf
### Networking infrastructure - VPCs, Subnets, Gateways, etc

resource "aws_vpc" "tutorial" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "tutorial" {
  vpc_id = "${aws_vpc.tutorial.id}"
  cidr_block = "10.0.8.0/24"
}

resource "aws_internet_gateway" "tutorial" {
  vpc_id = "${aws_vpc.tutorial.id}"
}

resource "aws_security_group" "tutorial_http" {
  vpc_id = "${aws_vpc.tutorial.id}"

  ingress {
    cidr_block =
    from_port = 0
    to_port = 80
    protocol = tcp
    }
}

### S3
### file s3.tf
### S3 bucket for site index page

resource "aws_s3_bucket" "hellocloud-tutorial-site-bucket" {
    bucket = "hellocloud-tutorial-site"
    acl = "public-read"
    policy = <<EOF
{
  "Id": "Policy1462998290938",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1462998074852",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::hellocloud-tutorial-site/*",
      "Principal": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_object" "site_object" {
    depends_on = ["aws_s3_bucket.hellocloud-tutorial-site-bucket"]
    bucket = "hellocloud-tutorial-site"
    key = "index.html"
    source = "s3/files/site/index.html"
    etag = "${md5(file("s3/files/site/index.html"))}"
}

### IAM
### file iam-roles.tf
### IAM profile and policy for S3 bucket access

resource "aws_iam_instance_profile" "bucket_access_instance_profile" {
  name = "bucket_access_instance_profile"
  roles = ["${aws_iam_role.bucket_access_role.name}"]
}

resource "aws_iam_role" "bucket_access_role" {
  name = "bucket_access_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bucket_access_policy" {
  name = "bucket_access_policy"
  role = "${aws_iam_role.bucket_access_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${var.s3SiteBucket}"]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${var.s3SiteBucket}/*"]
    }
  ]
}
EOF
}


### Instances
### file: instances.tf
### EC2 compute resources

resource "aws_instance" "tutorial" {
  # TODO: create ami with apache and very basic condition
  ami = "${var.ami}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags {
  		Name = "web"
  }
  iam_instance_profile = "${aws_iam_instance_profile.bucket_access_instance_profile.name}"
  key_name = "${var.key_name}"

  connection {
  	user = "ubuntu"
  	type = "ssh"
  	key_file = "${var.key_file}"
  	timeout = "2m"
  }
  provisioner "remote-exec" {
    	inline = [
      "sudo apt-get update",
      "sudo apt-get -y install awscli",
      "sudo apt-get -y install http2",
      "sudo systemctl restart apache2",
    	"sudo mkdir -p /var/www/html/",
    	"sudo aws s3 cp s3://${var.s3SiteBucket}/index.html /var/www/html/ --region=us-west-2"
    	]
    }
}

### Route53
### file route53.tf
### Route 53 record for Web Server

resource "aws_route53_record" "web" {
	zone_id = "PLACEHOLDER"
	name = "web.hellocloud-tutorial.io"
	type = "CNAME"
	ttl = "300"
	records = ["${aws_instance.tutorial.public_dns}"]
}

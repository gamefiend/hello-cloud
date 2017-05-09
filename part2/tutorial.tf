# Tutorial.tf (1-1)
# For sake of simplicity, we are putting everything in one file
# Normally, you will break each section into its own file for better
# organization. Each section will include the suggested file name
# to use if one were to break this single file out into parts.

### Variables
### file: variables.tf
### User-defined variables, if any

variable "size" {}

variable "instance_count" {
  type = "map"

  default = {
    "small" = 1
    "big"   = 3
  }
}

### Providers
### file:providers.tf
### Credentials for different providers we will use.

provider "aws" {
  region = "us-east-1"

  # You can delete these entries if you have ~/.aws/credentials file
  # or you export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  #access_key = "<YOUR KEY HERE>"
  #secret_key = "<YOUR SECRET HERE>"
}

### Network
### file: network.tf
### Networking infrastructure - VPCs, Subnets, Gateways, etc

resource "aws_vpc" "tutorial" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "hello-cloud"
  }
}

resource "aws_subnet" "tutorial" {
  vpc_id     = "${aws_vpc.tutorial.id}"
  # Conditional
  cidr_block = "${var.size == "small" ? "10.0.8.0/24" : "10.0.10.0/24"}"

  tags {
    Name = "hello-cloud"
  }
}

resource "aws_internet_gateway" "tutorial" {
  vpc_id = "${aws_vpc.tutorial.id}"
}

resource "aws_route_table" "tutorial" {
  vpc_id = "${aws_vpc.tutorial.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tutorial.id}"
  }

  tags {
    Name = "hello-cloud"
  }
}

resource "aws_route_table_association" "tutorial" {
  route_table_id = "${aws_route_table.tutorial.id}"
  subnet_id      = "${aws_subnet.tutorial.id}"
}

resource "aws_security_group" "tutorial_http" {
  vpc_id = "${aws_vpc.tutorial.id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  tags {
    Name = "hello-cloud"
  }
}

# get rid of the public ip

#resource "aws_eip" "tutorial" {
#  instance = ["${aws_instance.tutorial.*.id}"]
#  vpc = true
#}

### Instances
### file: instances.tf
### EC2 compute resources

resource "aws_instance" "tutorial" {
  ami                         = "ami-001d9868"
  instance_type               = "t2.nano"
  subnet_id                   = "${aws_subnet.tutorial.id}"
  vpc_security_group_ids      = ["${aws_security_group.tutorial_http.id}"]
  associate_public_ip_address = true

  tags {
    Name = "hello-cloud"
  }

  # ** Adding Lookup **
  count = "${lookup(var.instance_count,var.size)}"
}

### Outputs
### file: outputs.tf
### displays terraform variables

output "public_ips" {
  value = ["${aws_instance.tutorial.*.public_ip}"]
}

output "private_ips" {
  value = ["${aws_instance.tutorial.*.private_ip}"]
}

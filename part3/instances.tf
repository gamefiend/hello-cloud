### Instances
### file: instances.tf
### EC2 compute resources

resource "aws_instance" "tutorial" {
  ami = "ami-e4139df2"
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

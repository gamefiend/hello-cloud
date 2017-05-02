
# terraform variables

variable "aws_access_key_id" {
	default = ""
}

variable "aws_secret_access_key" {
	default = ""
}

variable "aws_region" {
	default = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
	# Ubuntu 14.04 LTS
	default = "ami-63ac5803"
	#
	#type = map
	# Amazon Linux AMI
	#default = {
		#"us-west-1": "ami-d13845e1"
		#"us-west-2": "ami-63ac5803"
	#}
}

variable "key_name" {
	default = ""
}

variable "key_file" {
	default = ""
}

variable "s3SiteBucket" {
	default = ""
}

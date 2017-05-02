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

### Instances
### file: instances.tf
### EC2 compute resources

resource "aws_instance" "tutorial" {
  # TODO: create ami with apache and very basic condition


}

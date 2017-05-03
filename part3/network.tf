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

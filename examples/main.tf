variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "private_ip" {}
variable "operator_group" {}
variable "operator_user" {}
variable "operator_password" {}
variable "ssh_security_group_name" {}
variable "outbound_security_group_name" {}
variable "docker_instance_name" {}

###############
# AWS provider
###############
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

##################
# Security groups
##################
resource "aws_security_group" "ssh" {
  name        = "${var.ssh_security_group_name}"
  description = "Default security group with ssh access for any ip-address"

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound" {
  name        = "${var.outbound_security_group_name}"
  description = "Default security group for outbound tcp traffic"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "rg-example"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "rg-example"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "rg-example"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "rg-example"
  }

  depends_on = ["aws_internet_gateway.gateway"]
}

resource "aws_eip" "elastic_ip" {
  vpc = true

  instance                  = "${module.server.id}"
  associate_with_private_ip = "${var.private_ip}"

  tags {
    Name = "rg-example"
  }

  depends_on = ["aws_internet_gateway.gateway"]
}

module "server" {
  source     = "github.com/ragedunicorn/terraform-aws-rg-docker"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region = "${var.aws_region}"

  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.outbound.id}",
  ]

  docker_instance_name = "${var.docker_instance_name}"
  private_ip           = "${var.private_ip}"
  subnet_id            = "${aws_subnet.subnet.id}"
  key_name             = "${var.key_name}"
  operator_user        = "${var.operator_user}"
  operator_group       = "${var.operator_group}"
  operator_password    = "${var.operator_password}"
}

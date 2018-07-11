variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
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

module "server" {
  source     = "github.com/ragedunicorn/terraform-aws-rg-docker"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region = "${var.aws_region}"

  security_groups = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.outbound.id}"
  ]

  key_name            = "${var.key_name}"
  operator_user       = "${var.operator_user}"
  operator_group      = "${var.operator_group}"
  operator_password   = "${var.operator_password}"
}

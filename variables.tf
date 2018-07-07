variable "access_key" {
  description = "The AWS access key"
}
variable "secret_key" {
  description = "The AWS secret key"
}

variable "aws_region" {
  description = "AWS region"
  default = "eu-central-1"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-c7e0c82c"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.medium"
}

variable "key_name" {
  description = "Name of the key to use. This key has to pre-exist in aws"
}

variable "security_groups" {
  description = "List of additional security groups that should get attached to the EC2 instances"
  type = "list"
  default = []
}

variable "default_security_group_name" {
  description = "Name of the default security group"
  default = "docker"
}

variable "docker_instance_name" {
  description = "Name of the instance"
  default = "docker-instance"
}

variable "operator_user_name" {
  description = "Name of the operator user"
  default = "operator"
}

variable "operator_group_name" {
  description = "Name of the operator group"
  default = "operator"
}

variable "operator_user_password" {
  description = "Password of the operator user"
}

variable "instance_entrypoint" {
  description = "Entrypoint script to execute"
  default = ""
}

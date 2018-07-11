variable "access_key" {
  description = "The AWS access key"
}

variable "secret_key" {
  description = "The AWS secret key"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-c7e0c82c"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.medium"
}

variable "key_name" {
  description = "Name of the key to use. This key has to pre-exist in aws"
}

variable "security_groups" {
  description = "List of additional security groups that should get attached to the EC2 instances"
  type        = "list"
  default     = []
}

variable "docker_instance_name" {
  description = "Name of the instance"
  default     = "docker-instance"
}

variable "instance_entrypoint" {
  description = "Entrypoint script to execute"
  default     = ""
}

variable "docker_channel" {
  description = "Docker channel. Either 'edge' or 'stable'"
  default     = "stable"
}

variable "docker_edition" {
  description = "Docker edition. Either Community Edition 'ce' or Enterprise Edition 'ee'"
  default     = "ce"
}

variable "docker_version" {
  description = "Docker version to install"
  default     = "18.03.1"
}

variable "docker_compose_version" {
  description = "Docker Compose version to install"
  default     = "1.21.0"
}

variable "docker_gpg_key" {
  description = "Docker repository GPG key"
  default     = "9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
}

variable "docker_repository" {
  description = "Docker repository path"
  default     = "deb [arch=amd64] https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} {{ docker_channel }}"
}

variable "docker_apt_package_name" {
  description = "Full APT docker package name"
  default     = "{{ docker_version }}~{{ docker_edition }}-0~{{ ansible_distribution | lower }}"
}

variable "docker_apt_cache_time" {
  description = "Time to cache apt-cache in seconds"
  default     = 86400
}

variable "create_operator_user" {
  description = "Whether to create an additional operator user"
  default     = true
}

variable "operator_group" {
  description = "Group of the operator account"
  default     = "operator"
}

variable "operator_user" {
  description = "User name of the operator account"
  default     = "operator"
}

variable "operator_password" {
  description = "Password of the operator account"
}

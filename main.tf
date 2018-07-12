# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy an ec2 instance with docker preinstalled
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

###############
# AWS provider
###############
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

############################
# Ansible Playbook template
############################
data "template_file" "ansible-playbook" {
  template = "${file("${path.module}/templates/ansible-playbook.tpl")}"

  vars {
    docker_channel          = "${var.docker_channel}"
    docker_edition          = "${var.docker_edition}"
    docker_version          = "${var.docker_version}"
    docker_compose_version  = "${var.docker_compose_version}"
    docker_gpg_key          = "${var.docker_gpg_key}"
    docker_repository       = "${var.docker_repository}"
    docker_apt_package_name = "${var.docker_apt_package_name}"
    docker_apt_cache_time   = "${var.docker_apt_cache_time}"
    create_operator_user    = "${var.create_operator_user}"
    operator_group          = "${var.operator_group}"
    operator_user           = "${var.operator_user}"
    operator_password       = "${var.operator_password}"
  }
}

######################
# Cloud-Init template
######################
data "template_file" "cloud-init" {
  template = "${file("${path.module}/templates/cloud-init.tpl")}"

  vars {
    ansible_playbook_docker = "${base64encode(data.template_file.ansible-playbook.rendered)}"
    instance_entrypoint = "${base64encode(var.instance_entrypoint)}"
  }
}

#############################
# Template cloud init config
#############################
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-init.rendered}"
  }
}

###############
# EC2 Instance
###############
resource "aws_instance" "docker_instance" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups}"]
  user_data              = "${data.template_cloudinit_config.config.rendered}"

  tags {
    Name = "${var.docker_instance_name}"
  }
}

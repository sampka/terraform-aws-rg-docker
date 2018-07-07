# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Deploy a docker ec2 instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

###############
# AWS provider
###############
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

###################################
# Module user-data template script
###################################
data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"

  vars {
    operator_user_name     = "${var.operator_user_name}"
    operator_group_name    = "${var.operator_group_name}"
    operator_user_password = "${var.operator_user_password}"
  }
}

#############################
# Template cloud init config
#############################
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # module init script
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }

  # user entrypoint script
  part {
    content_type = "text/x-shellscript"
    content      = "${var.instance_entrypoint}"
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
    Name  = "${var.docker_instance_name}"
  }
}

output "id" {
  description = "ID of the created instance"
  value       = "${aws_instance.docker_instance.id}"
}

output "availability_zone" {
  description = "Availability zone of the created instance"
  value       = "${aws_instance.docker_instance.availability_zone}"
}

output "key_name" {
  description = "Key name of the created instance"
  value       = "${aws_instance.docker_instance.key_name}"
}

output "public_ip" {
  description = "The public IP of the created ec2 instance"
  value       = "${aws_instance.docker_instance.public_ip}"
}

output "security_groups" {
  description = "List of associated security groups of the created instance"
  value       = ["${aws_instance.docker_instance.security_groups}"]
}

output "tags" {
  description = "List of tags for the created instance"
  value       = ["${aws_instance.docker_instance.tags}"]
}

output "generated_cloud_config" {
  description = "The rendered cloudinit config"
  value       = "${data.template_cloudinit_config.config.rendered}"
}

output "generated_cloud_init_config" {
  description = "The rendered cloud-init config"
  value       = "${data.template_file.cloud-init.rendered}"
}

output "generated_ansible_playbook" {
  description = "The rendered ansible playbook"
  value       = "${data.template_file.ansible-playbook.rendered}"
}

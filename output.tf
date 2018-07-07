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

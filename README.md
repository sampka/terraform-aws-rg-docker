# terraform-aws-rg-swarm

> Terraform module for creating a basic EC2 instance and docker installation

A Terraform module which creates an EC2 instance and preinstalls docker via `user_data`.

This module creates:
* a security group allowing ingress ssh access and egress on all ports.
* an ec2 instance

**Important**: This module does not expose any inbound or outbound ports on purpose. It is up to the user of this module to add security groups to allow ssh access and outbound traffic.

## Usage

```hcl
module "server" {
  source = "github.com/ragedunicorn/terraform-aws-rg-docker"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region = "${var.aws_region}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.default.id}"]
  instance_entrypoint = "${data.template_file.init.rendered}"
  operator_user_password = "${var.operator_user_password}"
}
```

## Inputs

| Name                        | Description                                                                      | Type   | Default           | Required |
|-----------------------------|----------------------------------------------------------------------------------|--------|-------------------|----------|
| access_key                  | The AWS access key                                                               | string | -                 | yes      |
| ami                         | Amazon Linux AMI                                                                 | string | `ami-c7e0c82c`    | no       |
| aws_region                  | AWS region                                                                       | string | `eu-central-1`    | no       |
| default_security_group_name | Name of the default security group                                               | string | `docker`          | no       |
| docker_instance_name        | Name of the instance                                                             | string | `docker-instance` | no       |
| instance_entrypoint         | Entrypoint script to execute                                                     | string | ``                | no       |
| instance_type               | Instance type                                                                    | string | `t2.medium`       | no       |
| key_name                    | Name of the key to use. This key has to pre-exist in aws                         | string | -                 | yes      |
| operator_group_name         | Name of the operator group                                                       | string | `operator`        | no       |
| operator_user_name          | Name of the operator user                                                        | string | `operator`        | no       |
| operator_user_password      | Password of the operator user                                                    | string | -                 | yes      |
| secret_key                  | The AWS secret key                                                               | string | -                 | yes      |
| security_groups             | List of additional security groups that should get attached to the EC2 instances | list   | `<list>`          | no       |

## Outputs

| Name              | Description                                                |
|-------------------|------------------------------------------------------------|
| availability_zone | Availability zone of the created instance                  |
| id                | ID of the created instance                                 |
| key_name          | Key name of the created instance                           |
| public_ip         | The public IP of the created ec2 instance                  |
| security_groups   | List of associated security groups of the created instance |
| tags              | List of tags for the created instance                      |

## Development

After creating the ec2 instance terraform will output the public address of the created instance.

```
ssh -i [key-path] ubuntu@[public-ip-address]
```

Examine logs

```
cat /var/log/syslog
```

This can be especially helpful if the user_data script doesn't seem to work.

## License

Copyright (C) 2018 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

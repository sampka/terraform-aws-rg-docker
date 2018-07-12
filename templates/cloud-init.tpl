#cloud-config
package_update: true
apt_sources:
 - source: "ppa:ansible/ansible"
packages:
  - ansible
write_files:
  - path: /tmp/ansible-playbook.yml
    content: |
      ${ansible_playbook_docker}
    owner: root:root
    encoding: b64
  - path: /tmp/instance-entrypoint.sh
    content: |
      ${instance_entrypoint}
    owner: root:root
    encoding: b64
    permissions: '0744'
runcmd:
  - [ ansible-playbook, /tmp/ansible-playbook.yml]
  - [ /tmp/instance-entrypoint.sh]
output:
  all: '| tee -a /var/log/cloud-init-output.log'

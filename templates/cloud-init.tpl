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
runcmd:
  - [ ansible-playbook, /tmp/ansible-playbook.yml]
output:
  all: '| tee -a /var/log/cloud-init-output.log'

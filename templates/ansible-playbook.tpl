---

- hosts: 127.0.0.1
  connection: local
  become: true
  become_user: root
  vars:
    docker_channel: "${docker_channel}"
    docker_edition: "${docker_edition}"
    docker_version: "${docker_version}"
    docker_compose_version: "${docker_compose_version}"
    docker_gpg_key: "${docker_gpg_key}"
    docker_repository: "${docker_repository}"
    docker_apt_package_name: "${docker_apt_package_name}"
    docker_apt_cache_time: ${docker_apt_cache_time}
    create_operator_user: ${create_operator_user}
    operator_group: "${operator_group}"
    operator_user: "${operator_user}"
    operator_password: "${operator_password}"
  tasks:
    - name: Install role dependencies
      apt:
        name: "{{item}}"
        state: "present"
        install_recommends: false
      with_items:
        - "apt-transport-https"
        - "ca-certificates"
        - "software-properties-common"
    - name: Import docker upstream APT GPG key
      apt_key:
        id: "{{docker_gpg_key}}"
        keyserver: "{{ansible_local.core.keyserver
          if (ansible_local|d() and ansible_local.core|d() and
            ansible_local.core.keyserver)
          else 'hkp://pool.sks-keyservers.net'}}"
        state: "present"
    - name: Configure docker upstream APT repository
      apt_repository:
        repo: "{{docker_repository}}"
        state: "present"
        update_cache: true
    - name: Install Docker
      apt:
        name: "docker-{{docker_edition}}={{docker_apt_package_name}}"
        state: "present"
        update_cache: true
        install_recommends: false
        cache_valid_time: "{{docker_apt_cache_time}}"
    - name: Install Docker Compose
      get_url:
        url: "https://github.com/docker/compose/releases/download/{{docker_compose_version}}/docker-compose-Linux-x86_64"
        dest: "/usr/local/bin/docker-compose"
        force: true
        owner: "root"
        group: "root"
        mode: "0755"
    - name: Create operator group
      group:
        name: "{{operator_group}}"
        state: present
    - name: Create operator user and add to docker group
      user:
        name: "{{operator_user}}"
        password: "{{operator_password}}"
        create_home: true
        shell: /bin/bash
        groups: "{{operator_group}},docker"
        append: yes
      when: create_operator_user

#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description script installing docker and creating an additional operator user

# abort when trying to use unset variable
set -o nounset

# install docker
echo "$(date) [INFO]: Installing docker-ce..."

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"

sudo apt update

sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

# create operator user
echo "$(date) [INFO]: Creating operator user: ${operator_user_name} with group - ${operator_group_name}"

sudo groupadd -g 9999 -r "${operator_group_name}"
sudo useradd -u 9999 -p `openssl passwd ${operator_user_password}` -r -g "${operator_group_name}" "${operator_user_name}"

# add operator user to docker group
echo "$(date) [INFO]: Adding operator user to docker group"
sudo usermod -aG docker "${operator_user_name}"

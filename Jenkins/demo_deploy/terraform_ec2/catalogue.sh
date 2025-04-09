#!/bin/bash
APP_VERSION=$1
yum install python3 python3-pip -y
pip3 install --upgrade pip
pip3 install ansible
ansible-playbook -i inventory -e ansible_user=ec2-user --private-key=/home/ec2-user/Linux/Jenkins/terraform.pem Ping.yaml
# cd /tmp
#ansible-pull -U https://github.com/cryl91/branch.git main.yaml -e app_version=$APP_VERSION

##In the above github account keep the ansible code to install the application
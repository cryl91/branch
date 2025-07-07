#!/bin/bash
APP_VERSION=$1
yum install python3 python3-pip -y
pip3 install --upgrade pip
pip3 install ansible
cd /tmp
ansible-pull -U https://github.com/cryl91/branch.git main.yaml -e app_version=$APP_VERSION 

##In the above github account keep the ansible code to install the application
# ansible-pull is the opposite of ansible-playbook.
#ansible-playbook: You push configurations from a control node (your laptop, Jenkins, etc.) to remote hosts.
#ansible-pull: The remote host pulls its configuration from a Git repo and applies it locally. This cmd is used from the target host (not from ansible's control node). 
#-U = Git URL to clone/playbook repo 
#Yes — to use ansible-pull, Ansible must be installed on the target host.
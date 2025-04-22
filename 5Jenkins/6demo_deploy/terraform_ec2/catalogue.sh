#!/bin/bash
set -xe

APP_VERSION=$1
yum install python3 python3-pip -y
pip3 install --upgrade pip
pip3 install ansible
cd /tmp
ansible-pull -U https://github.com/cryl91/ansible.git catalogue.yaml 

##In the above github account keep the ansible code to install the application
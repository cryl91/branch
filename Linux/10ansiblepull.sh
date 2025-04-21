#!/bin/bash
yum install python3 python3-pip -y
pip3 install --upgrade pip
pip3 install ansible
cd /tmp
ansible-pull -U https://github.com/cryl91/branch.git main.yaml
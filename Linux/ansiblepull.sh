#!/bin/bash
yum install python3 python3-pip -y
cd /tmp
ansible-pull -U https://github.com/cryl91/branch.git main.yaml
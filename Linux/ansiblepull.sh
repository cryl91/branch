#!/bin/bash
yum install python -y
cd /tmp
ansible-pull -U https://github.com/cryl91/branch.git main.yaml
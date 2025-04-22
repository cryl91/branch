#!/bin/bash

yum install ansible -y

#Steps to run ansible-roles
#cd /tmp
#git clone <repo http address>
#cd ansible-roboshop-role
#ansible-playbook -i inventory -e ansible_user=centos -e ansible_password=devops123
#-e component=mongodb main.yaml
#ansible-playbook -i inventory -e ansible_user=centos -e ansible_password=devops123
#-e component=catalogue main.yaml
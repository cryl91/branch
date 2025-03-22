#!/bin/bash

names=("mongodb" "redis")
instancetype=""
imageid=ami-08b5b3a93ed654d19
secgrp=sg-048539b811300092e

for i in ${names[@]}
do
    if [ $i == "mongodb" ]
    then 
    instancetype="t3.medium"
    else
    instancetype="t2.micro"
    fi
echo "creating $i"
ipaddress=$(aws ec2 run-instances --image-id $imageid --count 1 --instance-type $instancetype | jq -r '.instance[0].PrivateIpAddress')
echo "$ipaddress"
done

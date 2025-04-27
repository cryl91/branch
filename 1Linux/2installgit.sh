#!/bin/bash
user=$(id -u)
if [ $user -ne 0 ] #If = [], while = [ ], for = {}, date=$(date)
then
        echo "not root user"
        exit 1
fi

yum install git -y

if [ $? -ne 0 ]
then
        echo "failure"
exit 1
else
        echo "success"
fi

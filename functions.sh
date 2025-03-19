#!/bin/bash
user=$(id -u)

validate(){
if [ $1 -ne 0 ]
then
        echo "Installation failure"
        exit 1
else
        echo "Installation success"
fi

}


if [ $user -ne 0 ]
then
        echo "not root user"
        exit 1
fi

yum install git -y

validate $?
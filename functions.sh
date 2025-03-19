#!/bin/bash
user=$(id -u)
name=$0
file=/home/ec2-user/Linux/$name.log

validate(){
if [ $1 -ne 0 ] 
then
        echo "Installation failure"
        exit 1
else
        echo "$2 Installed success"
fi

}


if [ $user -ne 0 ]
then
        echo "not root user"
        exit 1
fi

yum list available git #check if git already installed or not
if [ $? -ne 0 ]
then 
yum install git -y &>> $file
validate $? "Installing git"
else
echo "git installed"
fi

yum list available postfix #check if git already installed or not
if [ $? -ne 0 ]
then 
yum install postfix -y &>> $file
validate $? "Installing postfix"
else 
echo "postfix installed"
fi

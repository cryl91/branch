#!/bin/bash
user=$(id -u)
name=$0
file=/home/ec2-user/Linux/$name.log

validate(){
if [ $1 -ne 0 ] 
then
        echo "Installing $2. Failure"
        exit 1
else
        echo "Instaled $2. Success"
fi

}

for i in $@
do 
yum list installed $i
if [ $? -ne 0 ]
    then 
        echo "$i not installed,lets install it"
        yum install $1 -y
        validate $? $1
    else
        echo "$i is already installed"
    fi
done
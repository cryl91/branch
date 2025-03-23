#!/bin/bash

disk_usage=$(df -hT | grep -vE 'tmpfs|Filesystem')
disk_usage_threshold=1
message=""

while IFS= read line
do

usage=$(echo $line | awk '{print $6}' | cut -d % -f1)
partition=$(echo $line | awk \ '{print $1}')
if [ $usage -gt $disk_usage_threshold ]
then
message+="High disk usage on $partition : $usage \n" 
fi
done <<< $disk_usage

echo "Message: $message"
#!/bin/bash
#a=1
#while [ $a -le 5 ] 
#do 
#echo "$a"
#((a++))
#done

while read line
do
echo "$line"
done < "code.sh"
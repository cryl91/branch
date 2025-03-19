#!/bin/bash
#a=1
#while [ $a -le 5 ] 
#do 
#echo "$a"
#((a++))
#done

#while read line
#do
#echo "$line"
#done < "Code.sh"

var=$1

while IFS= read -r line; do
    if [[ "$line" == *$var* ]]; then
        echo "Found it! --> $line"
        # Optionally exit the loop early
        break
    fi
done < Code.sh

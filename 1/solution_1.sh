#!/usr/bin/env sh

sum=0
while read -r line ; do
    
    case "${line}" in
        "")
            echo "Next elf, please!"
            list_of_summed="${list_of_summed},${sum}"
            sum=0
        ;;
        *)
            echo "Summing calories..."
            sum=$((sum+line))
        ;;
    esac
done < "${1}"

most_calories="$(echo ${list_of_summed} | tr ',' '\n' | sort -n | tail -n 1)"

echo
echo "Most calories carried by one elf - $most_calories"

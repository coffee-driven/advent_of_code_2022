#!/usr/bin/env sh

while read -r line ; do
    echo $line
    sum=0
    case "${line}" in
        "")
            list_of_summed="${list_of_summed},${sum}"
        ;;
        *)
            sum=$((sum+line))
        ;;
    esac
done < "${1}"

# echo ${list_of_summed} | tr ',' '\n' | sort | head -n 1

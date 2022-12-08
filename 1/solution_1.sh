#!/usr/bin/env sh

INPUT=${1:-./input}

# Part I
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
done < "${INPUT}"

most_calories="$(echo ${list_of_summed} | tr ',' '\n' | sort -n | tail -n 1)"

echo
echo "Most calories carried by one elf - $most_calories"

# Part II
top_three_calories="$(echo ${list_of_summed} | tr ',' '\n' | sort -n | tail -n 3 | tr '\n' " ")"

for cal in ${top_three_calories} ; do
    sum_of_top_three_cal=$((sum_of_top_three_cal+cal))
done

echo
echo "Total calories carried by top three elf - $sum_of_top_three_cal"

#!/usr/bin/env sh


INPUT=${1:-./input}


# Read input and create list of monkey pseudo structs
monkeys=""
while read -r line ; do
    case "${line}" in
        "")
            monkeys="|${monkeys}"
        ;;
        *)
            # echo "$line"
            monkeys="${line};${monkeys}"
        ;;
    esac
done < "${INPUT}"

# Source the values for each monkey's attribute, create list of those values. 
# Each monkey is separated by ";", 
# each value is separated by "_", 
# throwable items are separated by ","
IFS="|"
for monkeys_info in $monkeys ; do
    # echo '------'
    # echo "MONKEY INFO - $monkeys_info"

    IFS=';'
    i=-1
    for monkey_info in $monkeys_info ; do
        i=$((i+1))
        case $i in
            0)
                _if_false_throw_to_monkey="${monkey_info:-if true throw to monkey none}"
                if_false_throw_to_monkey="${_if_false_throw_to_monkey##* }"

                #echo "${if_false_throw_to_monkey}"
            ;;
            1)
                _if_true_throw_to_monkey="${monkey_info:-if true throw to monkey none}"
                if_true_throw_to_monkey="${_if_true_throw_to_monkey##* }"

                #echo "${if_true_throw_to_monkey}"
            ;;
            2)
                _divider_test_value="${monkey_info:-test: divisible by 0}"
                divider_test_value="${_divider_test_value##* }"

                #echo "${divider_test_value}"
            ;;
            3)
                _operation_new="${monkey_info:-operating: new = none}"
                operation_new="${_operation_new#*= }"
                change_worry_level_formula="${operation_new}"

                #echo "${change_worry_level_formula}"
            ;;
            4)
                _starting_items="${monkey_info:-starting items: 0}"
                starting_items="${_starting_items#*: }"

                #echo "${starting_items}"
            ;;
            5)
                _monkey="${monkey_info:-unknown 999:}"
                monkey="${_monkey#* }"
                monkey_number="${monkey%:}"

                #echo "${monkey_number}"
                #echo
                monkeys_struct="${monkey_number}_${starting_items}_${change_worry_level_formula}_${divider_test_value}_${if_true_throw_to_monkey}_${if_false_throw_to_monkey};${monkeys_struct}"
            ;;
        esac
    done
    # echo '------'
    # echo
done

echo "MONKEY BUSSINES DATA = $monkeys_struct"

# monkey logic
throw_to_monkey() {
    items="${1}"
    monkey_index="${2}"
    monkey_struct="${3}"

    OLD_IFS="$IFS"
    IFS=";"
    i=1
    for monkey in $monkey_struct ; do
        if ! [ $monkey_index -eq $i ] ; then
            i=$((i+1))
            continue
        else
            receiver_monkey="$monkey"
            break
        fi
    done

    _receiver_monkey_thwrowables="${receiver_monkey#*_}"
    receiver_monkey_thwrowables="${_receiver_monkey_thwrowables%_*_*_*_*}"
    receiver_monkey_thwrowables_updated="${receiver_monkey_thwrowables}, ${items}"

    # echo "$receiver_monkey_thwrowables_updated"

    i=0
    for monkey in $monkey_struct ; do
        if ! [ $monkey_index -eq $i ] ; then
            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey"
            fi
            i=$((i+1))
        else
            # Update monkey list
            IFS=" "
            i_n=0
            for item in $monkey ; do
                if [ $i_n -eq 0 ] ; then
                    monkey_updated="$receiver_monkey_thwrowables_updated $monkey_updated"
                else
                    monkey_updadted="$item $monkey_updated"
                fi
                i_n=$((i_n+1))

            done

            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey_updadted"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey_updadted"
            fi

        fi
    done
    
    monkeys_struct="$monkey_struct_updated"

    IFS="$OLD_IFS"
}

echo "ORIGINAL"
echo "$monkeys_struct"

throw_to_monkey "my, test" 2 "$monkeys_struct"


echo "UPDATED"
echo "$monkeys_struct"

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
    item="${1}"
    monkey_index="${2}"
    monkey_struct="${3}"

    IFS=";"
    i=0
    for monkey in $monkey_struct ; do
        if ! [ $monkey_index -eq $i ] ; then
            i=$((i+1))
            continue
        else
            receiver_monkey="$monkey"
            break
        fi
    done

    # Update receiver monkey list
    _receiver_monkey_thwrowables="${receiver_monkey#*_}"
    receiver_monkey_thwrowables="${_receiver_monkey_thwrowables%%_*}"

    # Throwable list is empty
    case "$receiver_monkey_thwrowables" in
        none)
            receiver_monkey_thwrowables_updated="${item}"
        ;;
        *)
            receiver_monkey_thwrowables_updated="${receiver_monkey_thwrowables}, ${item}"
        ;;
    esac

    # Update monkey attributes
    IFS="_"
    i=0
    for monkey_attribute in $receiver_monkey ; do
        case $i in
            0)
                monkey_updated="$monkey_attribute"
            ;;
            1)
                monkey_updated="${monkey_updated}_${receiver_monkey_thwrowables_updated}"
            ;;
            *)
                monkey_updated="${monkey_updated}_${monkey_attribute}"
            ;;
        esac
        i=$((i+1))
    done

    # Updat monkey struct
    IFS=";"
    i=0
    for monkey in $monkey_struct ; do
        if ! [ $monkey_index -eq $i ] ; then
            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey"
            fi
        else
            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey_updated"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey_updated"
            fi
        fi
        i=$((i+1))
    done

    printf '%s' "$monkey_struct_updated"
}

take_item() {
    this_monkey_index="${1}"
    monkeys_struct="${2}"

    OLD_IFS="$IFS"
    IFS=";"
    i=0
    for monkey in $monkeys_struct ; do
        if [ $this_monkey_index -eq $i ] ; then
            this_monkey="$monkey"
            break
        else
            i=$((i+1))
            continue
        fi
    done

    item_="${this_monkey#*_}"
    _item="${item_%%_*}"
    item="${_item%%,*}"

    IFS=","
    i=0
    for _ in $_item ; do
        i="$((i+1))"
    done

    case $i in
        1)
            this_monkey_items_updated="none"  
        ;;
        *)
            _this_monkey_items_updated="${_item#"${item}",}"
            this_monkey_items_updated="${_this_monkey_items_updated# }" 
        ;;
    esac

    # Update monkey struct
    IFS="$OLD_IFS"
    i=0
    for monkey in $monkeys_struct ; do
        if ! [ $this_monkey_index -eq $i ] ; then
            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey"
            fi
            i=$((i+1))
        else
            #echo "Getting item for monkey $this_monkey_index"
            # Update monkey list
            IFS="_"
            i_n=0
            monkey_updated=""
            for monkey_attribute in $(printf '%s' "$monkey") ; do
                if [ $i_n -eq 0 ] ; then
                    monkey_updated="$monkey_attribute"
                elif [ $i_n -eq 1 ] ; then
                    monkey_updated="${monkey_updated}_${this_monkey_items_updated}"
                else
                    monkey_updated="${monkey_updated}_${monkey_attribute}"
                fi
                i_n=$((i_n+1))
            done

            if [ $i -eq 0 ] ; then
                monkey_struct_updated="$monkey_updated"
            else
                monkey_struct_updated="$monkey_struct_updated;$monkey_updated"
            fi

            i=$((i+1))
        fi
    done
    
    monkeys_struct="$monkey_struct_updated"

    IFS="$OLD_IFS"

    printf '%s@%s' "$item" "$monkeys_struct"
}

create_new_item() {
    this_monkey_index="${1}"
    item="${2}"
    monkey_struct="${3}"

    OLD_IFS="$IFS"
    IFS=";"
    i=0
    for monkey in $monkey_struct ; do
        if [ $this_monkey_index -eq $i ] ; then
            this_monkey="$monkey"
            break
        else
            i=$((i+1))
            continue
        fi
    done

    _formula___="${this_monkey%_*}"
    _formula__="${_formula___%_*}"
    _formula_="${_formula__%_*}"
    formula="${_formula_##*_}"

    # echo "$formula"
    _x="${formula%% *}"
    _y="${formula##* }"
    _operator="${formula#* }"
    operator="${_operator% *}"

    case "$_x" in
        old)
            _x="$item"
        ;;
    esac
    case "$_y" in
        old)
            _y="$item"
        ;;
    esac

    case "$operator" in
        \+)
            _new="$(( _x + _y ))"
        ;;
        \*)
            _new="$(( _x * _y ))"
        ;;
    esac

    new=$((_new/3))

    printf '%s' "$new"
}

get_receiver_monkey() {
    this_monkey_index="${1}"
    item="${2}"
    monkey_struct="${3}"

    OLD_IFS="$IFS"
    IFS=";"
    i=0
    for monkey in $monkey_struct ; do
        if [ $this_monkey_index -eq $i ] ; then
            this_monkey="$monkey"
            break
        else
            i=$((i+1))
            continue
        fi
    done
    
    decision_logic="${this_monkey#*_*_*_}"
    divinder="${decision_logic%%_*}"
    reciever_false="${decision_logic##*_}"
    _receiver_true="${decision_logic#"${divinder}"_}"
    receiver_true="${_receiver_true%_*}"

    result="$((item%divinder))"
    case $result in
        0)
            receiver_monkey="$receiver_true"
        ;;
        *)
            receiver_monkey="$reciever_false"
        ;;
    esac

    printf '%s' "$receiver_monkey"

}


# Main
echo "Original struct - $monkeys_struct"

# Inspected items
M_0=0
M_1=0
M_2=0
M_3=0
M_4=0
M_5=0
M_6=0
M_7=0

# Traverse for section twenty times.
until [ $round -eq 20 ] ; do
for i in 0 1 2 3 4 5 6 7 ; do
    # Throw all throwables
    inspected=0
    while true ; do
        echo "Throwing"
        item_struct="$(take_item $i "$monkeys_struct")"
        item="${item_struct%%@*}"
        monkeys_struct="${item_struct##*@}"

        case $item in
            none)
                echo "This moneky has nothing to throw, next."
                break
            ;;
            *)
                inspected=$((inspected+1))
                echo "Worry level change"
                new_item="$(create_new_item $i "$item" "$monkeys_struct")"
                echo "new worry level $new_item"
                receiver=$(get_receiver_monkey $i "$new_item" "$monkeys_struct")
                echo "Throwing to monkey - $receiver"
                monkeys_struct="$(throw_to_monkey "$new_item" "$receiver" "$monkeys_struct")"
                # echo "struct $monkeys_struct"
            ;;
        esac
    done
    case $i in
        0)
            M_0=$((M_0+inspected))
        ;;
        1)
            M_1=$((M_1+inspected))
        ;;
        2)
            M_2=$((M_2+inspected))
        ;;
        3)
            M_3=$((M_3+inspected))
        ;;
        4)
            M_4=$((M_4+inspected))
        ;;
        5)
            M_5=$((M_5+inspected))
        ;;
        6)
            M_6=$((M_6+inspected))
        ;;
        7)
            M_7=$((M_7+inspected))
        ;;
    esac
    echo "Next monkey"
    echo
done
    round=$((round+1))
done

echo "Final structure -  $monkeys_struct"
echo
echo "Inspection list"
echo "Monkey 0 inspected $M_0"
echo "Monkey 1 inspected $M_1"
echo "Monkey 2 inspected $M_2"
echo "Monkey 3 inspected $M_3"
echo "Monkey 4 inspected $M_4"
echo "Monkey 5 inspected $M_5"
echo "Monkey 6 inspected $M_6"
echo "Monkey 7 inspected $M_7"

inspection_list="$M_0 $M_1 $M_2 $M_3 $M_4 $M_5 $M_6 $M_7"

# monkey business With help of external tools
monkey_business_values="$(echo "$inspection_list" | tr ' ' '\n' | sort -n | tail -n 2 | tr '\n' '_')"

_most_inspected="${monkey_business_values#*_}"
most_inspected="${_most_inspected%_}"
most_inspected_second="${monkey_business_values%%_*}"
monkey_business=$((most_inspected*most_inspected_second))

echo
echo "Monkey business $monkey_business"

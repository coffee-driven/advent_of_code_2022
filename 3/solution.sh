#!/usr/bin/env sh

INPUT=${1:-./input}

: <<'END'
ALL_VALUES_SUM=0

while read -r line ; do

    # Count letters in line
    slice=1
    while true ; do
        sliced=$(printf '%s' $line|cut -c $slice)
        case $sliced in
            "")
                line_slices=$((slice-1))
                echo "$line - $line_slices"
                break
            ;;
            *)
                slice=$((slice+1))
            ;;
        esac
    done

    half_length=$((slice/2))
    left_half=$(printf '%s' $line|cut -c -$half_length)
    right_half=${line#"$left_half"}
    shared_letters=""

    echo $left_half
    echo $right_half

    # Compare half of lines letter by letter
    slice=1
    while true ; do

        letter=$(printf '%s' $left_half|cut -c $slice)
        case $letter in
            "")
                break
            ;;
            *)
                slice=$((slice+1))
            ;;
        esac

        slice_inner=1
        while true ; do
            r_letter=$(printf '%s' $right_half|cut -c $slice_inner)

            case $r_letter in
                "")
                    break
                ;;
                $letter)
                    letter_present=false
                    for shared_letter in $shared_letters ; do
                        case $shared_letter in
                            $letter)
                                letter_present=true
                            ;;
                        esac
                    done
                    
                    case $letter_present in
                        true)
                            true
                        ;;
                        false)
                            shared_letters="${r_letter} ${shared_letters}"    
                        ;;
                    esac

                    break
                ;;
                *)
                    slice_inner=$((slice_inner+1))
                ;;
            esac
        done
    done

    echo "Shared values - $shared_letters"

    i=0
    for alpha in a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ; do
        i=$((i+1))
        for sl in $shared_letters ; do
            case $sl in
                $alpha)
                    value=$i
                ;;
            esac
        done
    done
    echo $value

    ALL_VALUES_SUM=$((ALL_VALUES_SUM+value))

done < "${INPUT}"

echo
echo "Total value - $ALL_VALUES_SUM"

END

# Part II
i=1
while read -r line ; do

    group_badges=""
    group_badges_adepts=""
    # Read three lines, each to it's own variable
    case $i in
        1)
            echo "Reading three lines"
            first=$line
            i=$((i+1))
            continue
        ;;
        2)
            second=$line
            i=$((i+1))
            continue
        ;;
        3)
            third=$line
            i=1
            echo "Lines has been read"
        ;;
    esac

    # Find shared letters within first two groups
    slice=1
    echo "Searching two first lines"
    while true ; do
        letter_first=$(printf '%s' $first|cut -c $slice)
        # echo $letter_first

        case $letter_first in
            "")
                break
            ;;
            *)  
                # Compare letter with all letters in second line
                inner_slice=1
                while true ; do
                    letter_second=$(printf '%s' $second|cut -c $inner_slice)
                    # echo $letter_second
                    case $letter_second in
                        "")
                            break
                        ;;
                        $letter_first)
                            # Check letter for presence in adepts group - avoid duplicities
                            echo "Found match for first two lines"
                            letter_already_present_in_group=false
                            for adept in $group_badges_adepts ; do
                                case $adept in
                                    $letter_first)
                                        letter_already_present_in_group=true
                                    ;;
                                esac
                            done
                            # Add letter to group when is not present in the group already
                            case $letter_already_present_in_group in
                                true)
                                    echo "Letter is already present in group"
                                    true
                                ;;
                                false)
                                    echo "Adding letter $first_letter to group"
                                    group_badges_adepts="$letter_first $group_badges_adepts"
                                ;;
                            esac
                            inner_slice=$((inner_slice+1))
                        ;;
                        *)
                            inner_slice=$((inner_slice+1))
                        ;;
                    esac
                done
            ;;
        esac

        slice=$((slice+1))
    done

    echo "Badget adepts - $group_badges_adepts"
    # For each letter in adepts group find match in third line
    echo "Searching third line"
    slice=1
    while true ; do
        letter_third=$(printf '%s' $third | cut -c $slice)

        case $letter_third in
            "")
                break
            ;;
            *)
                for badge_adept in $group_badges_adepts ; do
                    case $badge_adept in
                        $letter_third)
                            echo "Found match - $letter_third"
                            badge_already_present=false
                            for group_badge in $group_badges ; do
                                case $group_badge in
                                    "${letter_third}")
                                        badge_already_present=true
                                    ;;
                                    *)
                                        echo $group_badge
                                    ;;
                                esac
                            done
                            case $badge_already_present in
                                true)
                                    echo "Badge is already known"
                                ;;
                                false)
                                    echo "Found badge!"
                                    group_badges="${group_badges} ${letter_third}"
                                ;;
                            esac
                        ;;
                    esac
                done
            ;;
        esac

        slice=$((slice+1))
    done

    echo "Group badge - $group_badges"
    echo

    all_shared_badges="${group_badges} ${all_shared_badges}"

done < "${INPUT}"

echo "All badges - $all_shared_badges"

echo "Computing sum of value of badges"
all_badges_sum=0
for badge in $all_shared_badges ; do
    i=0
    for alpha in a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ; do
        i=$((i+1))
        case $badge in
            $alpha)
                all_badges_sum=$((all_badges_sum+i))
            ;;
        esac
    done
done

echo "Sum of all badges is - $all_badges_sum"
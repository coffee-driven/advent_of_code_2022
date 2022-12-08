#!/usr/bin/env sh

INPUT=${1:-./input}

# Part I
MY_TOTAL_SCORE=0

while read -r line ; do
    elf_choice="${line% *}"
    my_choice="${line#* }"

    echo "ROUND START"
    for val in A=1 B=2 C=3 X=1 Y=2 Z=3 ; do
        val_name=${val%=*}
        value=${val#*=}
        case ${val_name} in
            "${my_choice}")
                my_points=${value}
                echo "my points: $my_points"
            ;;
            "${elf_choice}")
                elf_points=${value}
                echo "elf points: $elf_points"
            ;;
        esac
    done
    echo "ROUND END"
    echo

    # Draw
    if [ $my_points -eq $elf_points ] ; then

        MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points+3))
        echo "No one won - it's draw."
        echo
        continue
        
    fi

    case $my_choice in
        # Rock
        X)
            case $elf_choice in
                # Paper
                B)
                    echo "I lost"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points))
                    echo
                ;;
                # Scisors
                C)
                    echo "I won"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points+6))
                    echo
                ;;
            esac
        ;;
        # Paper
        Y)
            case $elf_choice in
                # Scisors
                C)
                    echo "I lost"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points))
                    echo
                ;;
                # Rock
                A)
                    echo "I won"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points+6))
                    echo
                ;;
            esac
        ;;
        # Scisors
        Z)
            case $elf_choice in
                # Rock
                A)
                    echo "I lost"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points))
                    echo
                ;;
                # Paper
                B)
                    echo "I won"
                    MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_points+6))
                    echo
                ;;
            esac
        ;;
    esac


done < "${INPUT}"

echo
echo "My total score would be - $MY_TOTAL_SCORE"

# Part II
MY_TOTAL_SCORE=0

generate_choice_points() {

    oponent_choice="${1}"
    game_end="${2}"

    # This presents following matrix
    ## scisors(C) < rock(X) < paper(B)
    ## rock(A) < paper(Y) < scisors(C)
    ## paper(b) < scisors(Z) < rock(A)
    decision_model="C-A-B A-B-C B-C-A"

    points_mappers="A=1 B=2 C=3"

    for points_mapper in $points_mappers ; do
        name=${points_mapper%=*}
        value=${points_mapper#*=}

        case ${name} in
            $oponent_choice)
                oponent_points=$value
            ;;
        esac
    done

    case $game_end in
        draw)
            my_points=$oponent_points
            printf '%s' $my_points
            return
        ;;
    esac

    for concrete_decision_model in $decision_model ; do
        win_shape=${concrete_decision_model##*-}
        lose_shape=${concrete_decision_model%%-*}
        _oponent_shape=${concrete_decision_model#${lose_shape}-}
        oponent_shape=${_oponent_shape%-$win_shape}

        case $oponent_shape in 
            $oponent_choice)
                case $game_end in
                    lose)
                        for point_map in $points_mappers ; do
                            name=${point_map%=*}
                            value=${point_map#*=}

                            case ${name} in
                                $lose_shape)
                                    my_points=$value
                                    printf '%s' $my_points
                                    return
                                ;;
                            esac
                        done
                esac
                case $game_end in
                    win)
                        for point_map in $points_mappers ; do
                            name=${point_map%=*}
                            value=${point_map#*=}

                            case ${name} in
                                $win_shape)
                                    my_points=$value
                                    printf '%s' $my_points
                                    return
                                ;;
                            esac
                        done                  
                    ;;
                esac
            ;;
        esac
    done
}


while read -r line ; do
    elf_choice="${line% *}"
    round_ending="${line#* }"


    case $round_ending in
        X)
            echo "I lost"

            my_score=$(generate_choice_points $elf_choice lose)
            round_points=0
            MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_score+round_points))
            echo $MY_TOTAL_SCORE
            echo
        ;;
        Y)
            echo "It's draw"

            my_score=$(generate_choice_points $elf_choice draw)
            round_points=3
            MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_score+round_points))
            echo $MY_TOTAL_SCORE
            echo 
        ;;
        Z)
            echo "I win"

            my_score=$(generate_choice_points $elf_choice win)
            round_points=6
            MY_TOTAL_SCORE=$((MY_TOTAL_SCORE+my_score+round_points))
            echo  $MY_TOTAL_SCORE
            echo
        ;;
    esac


done < "${INPUT}"

echo
echo "My total score would be - $MY_TOTAL_SCORE"

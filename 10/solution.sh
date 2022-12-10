#!/usr/bin/env sh

INPUT=${1:-./input}
CRT_OUTPUT=${2:-./crt}

# Part II
crt() {
    echo "Crt draw pixel"
    sprite=$1
    sprite_left_pixel=$((sprite-1))
    sprite_right_pixel=$((sprite+1))
    width_pixel_index=${width_pixel_index:--1}

    # Move width cursor to next pixel
    width_pixel_index=$((width_pixel_index+1))

    # Draw (empty)pixel
    if [ $width_pixel_index -eq $sprite ] || [ $width_pixel_index -eq $sprite_left_pixel ] || [ $width_pixel_index -eq $sprite_right_pixel ] ; then
        CRT="$CRT$(printf '%s' "#")"
    else
        CRT="$CRT$(printf '%s' ".")"
    fi

    # Move height cursor on the next line and set width cursor to 0
    if [ $width_pixel_index -eq 39 ] ; then
        width_pixel_index=-1
        height_pixel_index=$((height_pixel_index+1))

        CRT="$CRT$(printf '%s' 'n')"
    fi
}


# Part I
X=1
CYCLES=0
SUM_OF_SIGNALS_STRENGTH=0

compute_signal_stregth() {
    # Check cycle number is milestone. Compute signal strength.
    echo "computing signal strength"
    cycles=$1
    register=$2

    for cycle_milestone in 20 60 100 140 180 220 ; do
        case $cycles in
            $cycle_milestone)
                echo "Cycle milestone $cycle_milestone - computing signal strength"
                
                signal_strength=$((cycle_milestone*register))
                echo "Current signal strength is $signal_strength"

                SUM_OF_SIGNALS_STRENGTH=$((signal_strength+SUM_OF_SIGNALS_STRENGTH))
                break
            ;;
        esac
    done
    echo "Computation aborted cycle count doesn't match milestone"
}

# Main - CPU 
while read -r instruction ; do
    echo "Cycling instruction $instruction"
    case ${instruction} in
        noop)
            CYCLES=$((CYCLES+1)) && compute_signal_stregth $CYCLES $X 
            crt $X
        ;;
        addx*)
            CYCLES=$((CYCLES+1)) && compute_signal_stregth $CYCLES $X 
            crt $X
            CYCLES=$((CYCLES+1)) && compute_signal_stregth $CYCLES $X
            crt $X

            addx_value="${instruction#* }"
            X=$((X+addx_value))
            echo "register is - $X"
        ;;
    esac 
    echo 
done < ${INPUT}

echo "Sum of signal strenghts is $SUM_OF_SIGNALS_STRENGTH"
echo

echo "CRT MODUL"
echo "   ||||||||||||||||||||||||||||||||||||||||||||   "
echo "   ++++++++++++++++++++++++++++++++++++++++++++"
IFS='n'
for crt_line in $CRT ; do
    printf '%s%s%s\n' "   ++" $crt_line "++"
done
echo "   ++++++++++++++++++++++++++++++++++++++++++++    "
echo "   ||||||||||||||||||||||||||||||||||||||||||||   "

#!/bin/bash

INPUT=$1
BASE_16_HEX=($(seq 0 9) a b c d e f)
RGB_LOOP=(0 1 2)
HUE_LOOP=(0 60 120 180 240 300)
declare -A BLA RED GRE YEL BLU MAG CYA WHI

rgb-set() {
  export R$1=$2 G$1=$3 B$1=$4 
}

main() {
  for RGB_LOOP_INDEX in "${RGB_LOOP[@]}"; do
    INDEX=0
    case "$RGB_LOOP_INDEX" in
      0) RGB=R0 IN0=${INPUT:0:1} IN1=${INPUT:1:1} ;;
      1) RGB=G0 IN0=${INPUT:2:1} IN1=${INPUT:3:1} ;;
      2) RGB=B0 IN0=${INPUT:4:1} IN1=${INPUT:5:1} ;;
    esac
    for HEX_INDEX in "${BASE_16_HEX[@]}"; do
      if [ "$HEX_INDEX" = "$IN0" ]; then
        OUT0=$(($INDEX*16))
      fi
      if [ "$HEX_INDEX" = "$IN1" ]; then
        OUT1=$INDEX
      fi
      ((INDEX++))
    done
    export $RGB=$(($OUT0+$OUT1))
  done
  #printf '%b\n' "\e[48;2;$R0;$G0;${B0}m $INPUT \n $R0,$G0,$B0 \e[0m"
  #printf '\n'
}

hue-shift() {
  for HUE_SHIFT in "${HUE_LOOP[@]}"; do
    case "$HUE_SHIFT" in
      0  ) rgb-set 1 $R0 $G0 $B0 ;; # red
      60 ) rgb-set 1 $R0 $R0 $B0 ;; # yellow
      120) rgb-set 1 $B0 $R0 $B0 ;; # green
      180) rgb-set 1 $B0 $R0 $R0 ;; # cyan
      240) rgb-set 1 $G0 $G0 $R0 ;; # blue
      300) rgb-set 1 $R0 $G0 $R0 ;; # magenta
    esac
    printf '%b\n' "\e[48;2;$R1;$G1;${B1}m $R1,$G1,$B1 \e[0m"
  done
}

main
hue-shift

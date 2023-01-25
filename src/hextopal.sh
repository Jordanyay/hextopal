#!/bin/bash

INPUT=$1
BASE_16_HEX=($(seq 0 9) a b c d e f)
RGB_LOOP=(0 1 2)

declare -A BLA RED GRE YEL BLU MAG CYA WHI

main() {
  for RGB_LOOP_INDEX in "${RGB_LOOP[@]}"; do
    INDEX=0
    case "$RGB_LOOP_INDEX" in
      0) RGB=R IN_0=${INPUT:0:1} IN_1=${INPUT:1:1} ;;
      1) RGB=G IN_0=${INPUT:2:1} IN_1=${INPUT:3:1} ;;
      2) RGB=B IN_0=${INPUT:4:1} IN_1=${INPUT:5:1} ;;
    esac
    for HEX_INDEX in "${BASE_16_HEX[@]}"; do
      if [ "$HEX_INDEX" = "$IN_0" ]; then
        OUT_0=$(($INDEX*16))
      fi
      if [ "$HEX_INDEX" = "$IN_1" ]; then
        OUT_1=$INDEX
      fi
      ((INDEX++))
    done
    declare $RGB=$(($OUT_0+$OUT_1))
  done
  printf '%b\n' "\e[48;2;$R;$G;${B}m $INPUT \n $R,$G,$B \e[0m"
}

main

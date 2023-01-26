#!/bin/bash

INPUT=$1
BASE_16_HEX=($(seq 0 9) a b c d e f)
RGB_LOOP=(0 1 2)
HUE_LOOP=(0 1 2 3 4 5)
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
    export $RGB=$(($OUT_0+$OUT_1))
  done
  printf '%b\n' "\e[48;2;$R;$G;${B}m $INPUT \n $R,$G,$B \e[0m"
  printf '\n'
}

hue-shift() {
  SHIFT=0
  for FUCK in "${HUE_LOOP[@]}"; do
    case "$SHIFT" in
      0  ) RN=$R GN=$G BN=$B ;;
      60 ) RN=$R GN=$R BN=$B ;;
      120) RN=$B GN=$R BN=$B ;;
      180) RN=$B GN=$R BN=$R ;;
      240) RN=$G GN=$G BN=$R ;;
      300) RN=$R GN=$G BN=$R ;;
      360) RN=$R GN=$G BN=$B ;;
    esac
    if [ "$RN" -gt '255' ]; then
      RN=255
    fi
    if [ "$RN" -lt '0' ]; then
      RN=0
    fi
    if [ "$GN" -gt '255' ]; then
      GN=255
    fi
    if [ "$GN" -lt '0' ]; then
      GN=0
    fi
    if [ "$BN" -gt '255' ]; then
      BN=255
    fi
    if [ "$BN" -lt '0' ]; then
      BN=0
    fi
    printf '%b\n' "\e[48;2;$RN;$GN;${BN}m $RN,$GN,$BN \e[0m"
    ((SHIFT=SHIFT+60))
  done
}

main
hue-shift $2

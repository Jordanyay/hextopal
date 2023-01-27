#!/bin/bash

INPUT=$1
BASE_16_HEX=($(seq 0 9) a b c d e f)
RGB_LOOP=(0 1 2)
HUE_LOOP=(0 60 120 180 240 300)

for RGB_LOOP_INDEX in "${RGB_LOOP[@]}"; do
  INDEX=0
  case "$RGB_LOOP_INDEX" in
    0) RGB=R IN0=${INPUT:0:1} IN1=${INPUT:1:1} ;;
    1) RGB=G IN0=${INPUT:2:1} IN1=${INPUT:3:1} ;;
    2) RGB=B IN0=${INPUT:4:1} IN1=${INPUT:5:1} ;;
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

for HUE_SHIFT in "${HUE_LOOP[@]}"; do
  case "$HUE_SHIFT" in
    0  ) RN=Red     RH=000000 RR=$R RG=$G RB=$B ;;
    60 ) YN=Yellow  YH=000000 YR=$R YG=$R YB=$B ;;
    120) GN=Green   GH=000000 GR=$B GG=$R GB=$B ;;
    180) CN=Cyan    CH=000000 CR=$B CG=$R CB=$R ;;
    240) BN=Blue    BH=000000 BR=$G BG=$G BB=$R ;;
    300) MN=Magenta MH=000000 MR=$R MG=$G MB=$R ;;
  esac
done

WIDTH='          '

print-blank() {
  blank() {
    printf "\e[48;2;$1;$2;${3}m$WIDTH\e[0m"
  }
  blank $RR $RG $RB
  blank $YR $YG $YB
  blank $GR $GG $GB
  blank $CR $CG $CB
  blank $BR $BG $BB
  blank $MR $MG $MB
  printf '\n'
}

print-blank

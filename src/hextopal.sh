#!/bin/bash

#############
# Variables #
#############

INPUT=$1
BASE_16_HEX=($(seq 0 9) a b c d e f)
RGB_LOOP=(0 1 2)
HUE_LOOP=(0 60 120 180 240 300)

######################
# Initial HEX to RGB #
######################

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

###################
# Base hue shifts #
###################

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

######################
# Initial RGB to B&W #
######################

GREYR=$(($RR*1000))
GREYG=$(($RG*1000))
GREYB=$(($RB*1000))

GREYR=$(($GREYR*299))
GREYG=$(($GREYG*587))
GREYB=$(($GREYB*114))

case "$(printf $GREYR | wc -m)" in
  7) if [ "${GREYR:1:1}" -ge '5' ]; then
       GREYR=$(printf "$GREYR" | cut -b 1) GREYR=$(($GREYR+1))
     else
       GREYR=$(printf "$GREYR" | cut -b 1)
     fi ;;
  8) if [ "${GREYR:2:1}" -ge '5' ]; then
       GREYR=$(printf "$GREYR" | cut -b 1-2) GREYR=$(($GREYR+1))
     else
       GREYR=$(printf "$GREYR" | cut -b 1-2)
     fi ;;
  9) if [ "${GREYR:3:1}" -ge '5' ]; then
       GREYR=$(printf "$GREYR" | cut -b 1-3) GREYR=$(($GREYR+1))
     else
       GREYR=$(printf "$GREYR" | cut -b 1-3)
     fi ;;
esac

case "$(printf $GREYG | wc -m)" in
  7) if [ "${GREYG:1:1}" -ge '5' ]; then
       GREYG=$(printf "$GREYG" | cut -b 1) GREYG=$(($GREYG+1))
     else
       GREYG=$(printf "$GREYG" | cut -b 1)
     fi ;;
  8) if [ "${GREYG:2:1}" -ge '5' ]; then
       GREYG=$(printf "$GREYG" | cut -b 1-2) GREYG=$(($GREYG+1))
     else
       GREYG=$(printf "$GREYG" | cut -b 1-2)
     fi ;;
  9) if [ "${GREYG:3:1}" -ge '5' ]; then
       GREYG=$(printf "$GREYG" | cut -b 1-3) GREYG=$(($GREYG+1))
     else
       GREYG=$(printf "$GREYG" | cut -b 1-3)
     fi ;;
esac

case "$(printf $GREYB | wc -m)" in
  7) if [ "${GREYB:1:1}" -ge '5' ]; then
       GREYB=$(printf "$GREYB" | cut -b 1) GREYB=$(($GREYB+1))
     else
       GREYB=$(printf "$GREYB" | cut -b 1)
     fi ;;
  8) if [ "${GREYB:2:1}" -ge '5' ]; then
       GREYB=$(printf "$GREYB" | cut -b 1-2) GREYB=$(($GREYB+1))
     else
       GREYB=$(printf "$GREYB" | cut -b 1-2)
     fi ;;
  9) if [ "${GREYB:3:1}" -ge '5' ]; then
       GREYB=$(printf "$GREYB" | cut -b 1-3) GREYB=$(($GREYB+1))
     else
       GREYB=$(printf "$GREYB" | cut -b 1-3)
     fi ;;
esac

GREY_SUM=$(($GREYR+$GREYG+$GREYB))

printf '%s\n' "$RR $RG $RB"
printf '%s\n' "$GREYR $GREYG $GREYB"
printf '%s\n' "$(($GREYR+$GREYG+$GREYB))"

##################
# Block printing #
##################

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
  blank $GREY_SUM $GREY_SUM $GREY_SUM
  printf '\n'
}

print-blank

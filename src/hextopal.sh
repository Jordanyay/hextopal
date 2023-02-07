#!/bin/bash

grab() {
  case "$1" in
    DAR) printf '%s\n' "${DAR[$2]}" ;;
    RED) printf '%s\n' "${RED[$2]}" ;;
    YEL) printf '%s\n' "${YEL[$2]}" ;;
    GRE) printf '%s\n' "${GRE[$2]}" ;;
    CYA) printf '%s\n' "${CYA[$2]}" ;;
    BLU) printf '%s\n' "${BLU[$2]}" ;;
    MAG) printf '%s\n' "${MAG[$2]}" ;;
    LIG) printf '%s\n' "${LIG[$2]}" ;;
  esac
}

######################
# Initial HEX to RGB #
######################

for RGB_LOOP_INDEX in {0..2}; do
  INDEX=0
  case "$RGB_LOOP_INDEX" in
    0) RGB=R IN0=${1:0:1} IN1=${1:1:1} ;;
    1) RGB=G IN0=${1:2:1} IN1=${1:3:1} ;;
    2) RGB=B IN0=${1:4:1} IN1=${1:5:1} ;;
  esac
  for HEX_INDEX in {0..9} {a..f}; do
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

for HUE_SHIFT in {0..300..60}; do
  case "$HUE_SHIFT" in
    0  ) declare -A RED=([NAME]=Red     [HEX]=000000 [RGB]="$R $G $B" [R]=$R [G]=$G [B]=$B) ;;
    60 ) declare -A YEL=([NAME]=Yellow  [HEX]=000000 [RGB]="$R $R $B" [R]=$R [G]=$R [B]=$B) ;;
    120) declare -A GRE=([NAME]=Green   [HEX]=000000 [RGB]="$B $R $B" [R]=$B [G]=$R [B]=$B) ;;
    180) declare -A CYA=([NAME]=Cyan    [HEX]=000000 [RGB]="$B $R $R" [R]=$B [G]=$R [B]=$R) ;;
    240) declare -A BLU=([NAME]=Blue    [HEX]=000000 [RGB]="$G $G $R" [R]=$G [G]=$G [B]=$R) ;;
    300) declare -A MAG=([NAME]=Magenta [HEX]=000000 [RGB]="$R $G $R" [R]=$R [G]=$G [B]=$R) ;;
  esac
done

######################
# Initial RGB to B&W #
######################

GREYR=$(($(grab RED R)*1000))
GREYG=$(($(grab RED G)*1000))
GREYB=$(($(grab RED B)*1000))

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

printf '%s\n' "$(grab RED RGB)"
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
  blank $(grab RED RGB)
  blank $(grab YEL RGB)
  blank $(grab GRE RGB)
  blank $(grab CYA RGB)
  blank $(grab BLU RGB)
  blank $(grab MAG RGB)
  printf '\n'
  blank $GREY_SUM $GREY_SUM $GREY_SUM
  printf '\n'
}

print-blank

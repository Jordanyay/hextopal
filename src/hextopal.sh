#!/bin/bash

prop-get() {
  case "$1" in
    BLA) printf "${BLA[$2]}" ;;
    RED) printf "${RED[$2]}" ;;
    YEL) printf "${YEL[$2]}" ;;
    GRE) printf "${GRE[$2]}" ;;
    CYA) printf "${CYA[$2]}" ;;
    BLU) printf "${BLU[$2]}" ;;
    MAG) printf "${MAG[$2]}" ;;
    WHI) printf "${WHI[$2]}" ;;
  esac
}

######################
# Initial HEX to RGB #
######################

for i in {0..2}; do
  INDEX=0
  case "$i" in
    0) RGB=R IN0=${1:0:1} IN1=${1:1:1} ;;
    1) RGB=G IN0=${1:2:1} IN1=${1:3:1} ;;
    2) RGB=B IN0=${1:4:1} IN1=${1:5:1} ;;
  esac
  for i in {0..9} {a..f}; do
    if [ "$i" = "$IN0" ]; then
      OUT0=$(($INDEX*16))
    fi
    if [ "$i" = "$IN1" ]; then
      OUT1=$INDEX
    fi
    ((INDEX++))
  done
  export $RGB=$(($OUT0+$OUT1))
done

###################
# Base hue shifts #
###################

for i in {0..300..60}; do
  case "$i" in
    0  ) declare -A RED=([NAME]=Red     [HEX]=$H [RGB]="$R $G $B" [R]=$R [G]=$G [B]=$B) ;;
    60 ) declare -A YEL=([NAME]=Yellow  [HEX]=$H [RGB]="$R $R $B" [R]=$R [G]=$R [B]=$B) ;;
    120) declare -A GRE=([NAME]=Green   [HEX]=$H [RGB]="$B $R $B" [R]=$B [G]=$R [B]=$B) ;;
    180) declare -A CYA=([NAME]=Cyan    [HEX]=$H [RGB]="$B $R $R" [R]=$B [G]=$R [B]=$R) ;;
    240) declare -A BLU=([NAME]=Blue    [HEX]=$H [RGB]="$G $G $R" [R]=$G [G]=$G [B]=$R) ;;
    300) declare -A MAG=([NAME]=Magenta [HEX]=$H [RGB]="$R $G $R" [R]=$R [G]=$G [B]=$R) ;;
  esac
done

######################
# Initial RGB to B&W #
######################

GREYR=$(($(prop-get RED R)*1000))
GREYG=$(($(prop-get RED G)*1000))
GREYB=$(($(prop-get RED B)*1000))

GREYR=$(($GREYR*299))
GREYG=$(($GREYG*587))
GREYB=$(($GREYB*114))

for i in $GREYR $GREYG $GREYB; do
  case $i in
    $GREYR) foo=GREYR ;;
    $GREYG) foo=GREYG ;;
    $GREYB) foo=GREYB ;;
  esac
  case "$(printf $i | wc -m)" in
    7) if [ "${i:1:1}" -ge '5' ]; then
         export $foo=$(printf "$i" | cut -b 1)
         export $foo=$(($foo+1))
       else
         export $foo=$(printf "$i" | cut -b 1)
       fi ;;
    8) if [ "${i:2:1}" -ge '5' ]; then
         export $foo=$(printf "$i" | cut -b 1-2) 
         export $foo=$(($foo+1))
       else
         export $foo=$(printf "$i" | cut -b 1-2)
       fi ;;
    9) if [ "${i:3:1}" -ge '5' ]; then
         export $foo=$(printf "$i" | cut -b 1-3)
         export $foo=$(($foo+1))
       else
         export $foo=$(printf "$i" | cut -b 1-3)
       fi ;;
  esac
done

if [ "$GREYR" -ge "$GREYG" ] && [ "$GREYR" -ge "$GREYB" ]; then
  GREY=$GREYR
elif [ "$GREYG" -ge "$GREYB" ]; then
  GREY=$GREYG
else
  GREY=$GREYB
fi

black-calculator() {
  local MAX=$(printf '%s\n' "$(prop-get RED R)" "$(prop-get RED G)" "$(prop-get RED B)" | sort -n | tail -n 1)
  local MIN=$(printf '%s\n' "$(prop-get RED R)" "$(prop-get RED G)" "$(prop-get RED B)" | sort -n | head -n 1)
  printf '%s\n' "$((($MAX*$MIN)/1000))"
}

white-calculator() {
  local MAX=$(printf '%s\n' "$(prop-get RED R)" "$(prop-get RED G)" "$(prop-get RED B)" | sort -n | tail -n 1)
  printf '%s\n' "$MAX"
}

DAR=$(black-calculator)
LIG=$(white-calculator)

if [ "$DAR" -le 0 ]; then
  DAR=0
fi
if [ "$LIG" -ge 255 ]; then
  LIG=255
fi

declare -A BLA=([NAME]=Black [HEX]=$H [RGB]="$DAR $DAR $DAR" [R]=$DAR [G]=$DAR [B]=$DAR)
declare -A WHI=([NAME]=White [HEX]=$H [RGB]="$LIG $LIG $LIG" [R]=$LIG [G]=$LIG [B]=$LIG)

printf '%s\n' "$(prop-get BLA RGB)"
printf '%s\n' "$(prop-get RED RGB)"
printf '%s\n' "$(prop-get YEL RGB)"
printf '%s\n' "$(prop-get GRE RGB)"
printf '%s\n' "$(prop-get CYA RGB)"
printf '%s\n' "$(prop-get BLU RGB)"
printf '%s\n' "$(prop-get MAG RGB)"
printf '%s\n' "$(prop-get WHI RGB)"
#printf '%s\n' "$GREYR $GREYG $GREYB"

##################
# Block printing #
##################

WIDTH='          '

print-blank() {
  blank() {
    printf "\e[48;2;$1;$2;${3}m$WIDTH\e[0m"
  }
  blank $(prop-get BLA RGB)
  blank $(prop-get RED RGB)
  blank $(prop-get YEL RGB)
  blank $(prop-get GRE RGB)
  blank $(prop-get CYA RGB)
  blank $(prop-get BLU RGB)
  blank $(prop-get MAG RGB)
  blank $(prop-get WHI RGB)
  printf '\n'
  blank $(prop-get BLA RGB)
  blank $GREY $GREY $GREY
  printf '\n'
}

print-blank

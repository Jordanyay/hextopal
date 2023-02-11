#!/bin/bash

H=000000

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

###############
# Base colors #
###############

color() {
  export $1_N=$2
  export $1_H=$3
  export $1_R=$4
  export $1_G=$5
  export $1_B=$6
  export $1_RGB="$4 $5 $6"
}

color RED Red     $H $R $G $B
color YEL Yellow  $H $R $R $B
color GRE Green   $H $B $R $B
color CYA Cyan    $H $B $R $R
color BLU Blue    $H $G $G $R
color MAG Magenta $H $R $G $R

MAX=$(printf '%s\n' "$RED_R" "$RED_G" "$RED_B" | sort -n | tail -n 1)
MIN=$(printf '%s\n' "$RED_R" "$RED_G" "$RED_B" | sort -n | head -n 1)
DAR=$((($MAX*$MIN)/1000))

MAX=$(printf '%s\n' "$RED_R" "$RED_G" "$RED_B" | sort -n | tail -n 1)
LIG=$MAX

if [ "$DAR" -le 0 ]; then
  DAR=0
fi
if [ "$LIG" -ge 255 ]; then
  LIG=255
fi

color BLA Black $H $DAR $DAR $DAR
color WHI White $H $LIG $LIG $LIG

############################
# Base colors to greyscale #
############################

for WASHED in RED_WAS YEL_WAS GRE_WAS CYA_WAS BLU_WAS MAG_WAS; do
  R=$((($(printf "$WASHED" | head -c 3)_R*1000)*299))
  G=$((($(printf "$WASHED" | head -c 3)_G*1000)*587))
  B=$((($(printf "$WASHED" | head -c 3)_B*1000)*114))

  i=$(($(($R+$G+$B))/3))

  case "$(printf $i | wc -m)" in
    7) if [ "${i:1:1}" -ge '5' ]; then
         W=$(($(printf "$i" | cut -b 1)+1))
       else
         W=$(printf "$i" | cut -b 1)
       fi ;;
    8) if [ "${i:2:1}" -ge '5' ]; then
         W=$(($(printf "$i" | cut -b 1-2)+1))
       else
         W=$(printf "$i" | cut -b 1-2)
       fi ;;
    9) if [ "${i:3:1}" -ge '5' ]; then
         W=$(($(printf "$i" | cut -b 1-3)+1))
       else
         W=$(printf "$i" | cut -b 1-3)
       fi ;;
  esac
  export $WASHED="$W $W $W"
done

############
# Printing #
############

printf '\n'
printf '%s\n' "$BLA_RGB"
printf '%s\n' "$RED_RGB"
printf '%s\n' "$YEL_RGB"
printf '%s\n' "$GRE_RGB"
printf '%s\n' "$CYA_RGB"
printf '%s\n' "$BLU_RGB"
printf '%s\n' "$MAG_RGB"
printf '%s\n' "$WHI_RGB"
printf '\n'
printf '%s\n' "$BLA_RGB"
printf '%s\n' "$RED_WAS"
printf '%s\n' "$YEL_WAS"
printf '%s\n' "$GRE_WAS"
printf '%s\n' "$CYA_WAS"
printf '%s\n' "$BLU_WAS"
printf '%s\n' "$MAG_WAS"
printf '%s\n' "$WHI_RGB"
printf '\n'

##########
# Blocks #
##########

WIDTH='          '

blank() {
  printf "\e[48;2;$1;$2;${3}m$WIDTH\e[0m"
}

blank $BLA_RGB
blank $RED_RGB
blank $YEL_RGB
blank $GRE_RGB
blank $CYA_RGB
blank $BLU_RGB
blank $MAG_RGB
blank $WHI_RGB
printf '\n'
blank $BLA_RGB
blank $RED_WAS
blank $YEL_WAS
blank $GRE_WAS
blank $CYA_WAS
blank $BLU_WAS
blank $MAG_WAS
blank $WHI_RGB
printf '\n\n'

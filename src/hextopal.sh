#!/bin/bash

declare -A DA RE GR YE BL MA CY LI

MA[COLOR]='magenta'
MA[R]='yes'

printf '%s\n' "${MA[$1]}"

#block-info () {
#  BLOCK=("${BLA[$2]}" "${RED[$2]}" "${GRE[$2]}")
#  printf "${BLOCK[$1]}"
#  if [ "$3" = '1' ]; then
#    printf '\n'
#  fi
#}
#
#block-info $1 $2 $3

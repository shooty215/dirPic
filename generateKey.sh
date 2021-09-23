#!/bin/bash
for i in {0..31}
do
RANDOM=$(date +%s%N | cut -b10-19)
bit=$(( $RANDOM % 128 + 0 ))
hexbit=$(printf '%x\n' $bit)
if [ ${#hexbit} -eq 1 ]
then
  hexbit="0${hexbit}"
fi
key="${key}$hexbit"
done
echo $key
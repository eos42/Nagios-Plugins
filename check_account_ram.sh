#!/bin/bash
DIR=/opt
CLEOS=$DIR/cleos.sh

MAX=80

RAMA=$($CLEOS get account bidchextoken -j | jq -r ".ram_quota")
RAMU=$($CLEOS get account bidchextoken -j | jq -r ".ram_usage")
RAMR="(($RAMU/$RAMA)*100)"
RAMRA=$(echo "scale=4; ${RAMR}" | bc | cut -d'.' -f 1 | sed 's/ //g')




if (( $(echo "$RAMA > $MAX" |bc -l) )); then
  echo "bidchexrtoken RAM is above $MAX usage, currently at $RAMRA usage | ChintaileaseRAM=$RAMRA"
  exit 2
else
  echo "bidchexrtoken RAM is below $MAX usage, currently averaging $RAMRA usage | ChintaileaseRAM=$RAMRA"
  exit 0
fi

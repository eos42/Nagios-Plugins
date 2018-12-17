#!/bin/bash
DIR=/opt
CLEOS=$DIR/cleos.sh

#Set max CPU average to compare against
MAX=30

#Create blank file
echo -n >CPUSTATS


end=$((SECONDS+60))
while [ $SECONDS -lt $end ]; do   # Loop until interval has elapsed.

        CPUA=$($CLEOS get account chintailease -j | jq -r ".cpu_limit.available")
        CPUU=$($CLEOS get account chintailease -j | jq -r ".cpu_limit.used")
        CPUR="(($CPUU/$CPUA)*100)"
        CPURA=$(echo "scale=4; ${CPUR}" | bc | cut -d'.' -f 1 | sed 's/ //g')
        # Append each line to CPUSTATS file
        echo $CPURA>>CPUSTATS

done

#Compute the average
AVG=$(awk '{s+=$1} END {print s/NR}' CPUSTATS)


if (( $(echo "$AVG > $MAX" |bc -l) )); then
  echo "Chintai CPU is above $MAX usage, currently averaging $AVG usage | Chintaileasecpu=$AVG "
  exit 2
else
  echo "Chintai CPU is below $MAX usage, currently averaging $AVG usage | Chintaileasecpu=$AVG"
  exit 0
fi

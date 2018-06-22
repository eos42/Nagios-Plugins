#!/bin/bash
PATH=/usr/local/nagios/
FILEDIR=/usr/local/nagios/unpaid_blocks.temp
CLEOS=/opt

if [[ $1 -eq 1 ]]; then
        echo "Creating blank unpaid_blocks.temp..."
        "-1">$FILEDIR
fi

OLD=$(<$FILEDIR)
echo "Old unpaid_blocks: $OLD"
UNPAID="$(/bin/bash $CLEOS/cleos.sh get table eosio eosio producers -l 150 | /bin/grep -A 6 "eos42freedom" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
echo $UNPAID > $FILEDIR

if [[ $UNPAID -eq $OLD ]];
then
  echo "Not Producing"
  exit 2
else
  echo "Successfully Producing" >&2
  exit 0
fi

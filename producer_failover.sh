#!/bin/bash
# Make sure you have a backup producer running with a producer key and add this to signing_key
PATH=/home/ubuntu/trusted

MAINNETDIR=/home/ubuntu/trusted
FILEDIR=/home/ubuntu/trusted/unpaid_blocks.temp
WALLETPW=
#Signing key of the other producers
SIGNING_KEY=

if [[ $1 -eq 1 ]]; then
        echo "Creating blank unpaid_blocks.temp..."
        "-1">$FILEDIR
fi

OLD=$(<$FILEDIR)
echo "Old unpaid_blocks: $OLD"
UNPAID="$(/bin/bash $MAINNETDIR/cleos.sh get table eosio eosio producers -l 1000000 | /bin/grep -A 6 "hkeoshkeosbp" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
echo $UNPAID > $FILEDIR

if [[ $UNPAID -eq $OLD ]]; then
        echo "Producer is idle. Switching to secondary now..."
        $MAINNETDIR/cleos.sh wallet unlock --password $WALLETPW
        $MAINNETDIR/cleos.sh system regproducer hkeoshkeosbp $SIGNING_KEY "https://hkeos.com" 344
fi

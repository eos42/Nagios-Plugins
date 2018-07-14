#!/bin/bash
################################################################################
#
# Script created by @samnoble @ankh2054 for https://eosdublin.com & https://www.eos42.io
#
# Visit https://github.com/eos42/Nagios-Plugins/ for details.
#
################################################################################
DIR=/opt
PRODUCER={add your producer}
producer_state=$($DIR/./cleos.sh get table eosio eosio producers -l 1 -k owner -L eos42freedom)
TIMESTAMP=$(echo $producer_state | jq -r '.rows[0].last_claim_time')
let LAST_CLAIM_TIME=$TIMESTAMP/1000000
LAST_CLAIM_TIMESTAMP=$(date -d @$LAST_CLAIM_TIME)
CURRENT_TIME=$(date +%s)
let LAST_CLAIM_TIME_SECONDS=$CURRENT_TIME-$LAST_CLAIM_TIME
DAY=86400
if [ $LAST_CLAIM_TIME_SECONDS -gt $DAY ]; then
        echo "Your last claim was over 24 hours ago"
        exit 2
else
        echo "Last claim action was on ${LAST_CLAIM_TIMESTAMP}"
        exit 0
fi

#!/bin/bash
################################################################################
#
# Script created by @samnoble @ankh2054 for https://eosdublin.com & https://www.eos42.io
#
# Visit https://github.com/eos42/Nagios-Plugins/ for details.
#
################################################################################
DIR=/Ghostbusters/ghostbusters-eos42freedom
PRODUCER=eos42freedom
producer_state=$($DIR/./cleos.sh get table eosio eosio producers -l 1 -k owner -L eos42freedom)
TIMESTAMP=$(echo $producer_state | jq -r '.rows[0].last_claim_time')
let LAST_CLAIM_TIME=$TIMESTAMP/1000000
current_time=$(date +%s)
let last_claim_time_seconds=$current_time-$LAST_CLAIM_TIME
DAY=86400
if [ $last_claim_time_seconds -gt $DAY ]; then
        echo "Your last claim was over 24 hours ago"
        exit 2
else
        echo "You have claimed in the last 24 hours"
        exit 0
fi

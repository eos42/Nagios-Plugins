#!/bin/bash
HISTORY=/home/charles/.bash_history
# Checks for wallet passwords or private keys
PATTERN='PW5\|5J\|5K'
COUNT=`/bin/grep "$PATTERN" $HISTORY | /usr/bin/wc -l`
if [ $COUNT -ne 0 ]
then
     echo "You are being a idiot"
else
     echo "You are being a good secure BP"
fi

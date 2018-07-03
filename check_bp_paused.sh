#!/bin/bash

############################################################################################
#
# This script is to check that your backup producer is in paused mode
#
#
# Made with <3 by Charles @ EOS42
#
############################################################################################

# Change these vars based on your node configuration
NODEOS_HTTP=$1
NODEOS_PORT=8888



# Based on the state, perform the relevant action
 RESULT=$(curl -s "http://$NODEOS_HTTP:$NODEOS_PORT/v1/producer/paused")
      if [ "$RESULT" == "true" ]
      then
          echo "Backup Producer remains in paused state."
          exit 0
      else
          echo "Backup Producer is now also trying to produce"
          exit 2
      fi

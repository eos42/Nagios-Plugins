#!/bin/bash
FILEEOS42=/usr/local/nagios/unpaid_blocks_eos42.temp
FILEBOS42=/usr/local/nagios/unpaid_blocks_bos42.temp
CLEOS=/opt/cleos.sh
BLEOS=/opt/bleos.sh


if [ $# -eq 0 ]
  then
    echo "Please provide eos42 or bos42 as your argument"
fi


if [[ $1 == "eos42" ]]; then

    # Check if eos42freedom is in top21
    BP=$($CLEOS system listproducers -j -l 21 | jq ".rows[].owner" | grep -c eos42freedom) 

    if [ $BP -gt 0 ];
		then
	        OLD=$(<$FILEEOS42)
	        echo "Old unpaid_blocks: $OLD"
	        UNPAID="$(/bin/bash $CLEOS get table eosio eosio producers -l 150 | /bin/grep -A 6 "eos42freedom" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
	        echo $UNPAID > $FILEEOS42

	        if [[ $UNPAID -eq $OLD ]];
	        then
	          echo "Not Producing"
	          exit 2
	        else
	          echo "Successfully Producing" >&2
	          exit 0
	        fi
	    else
            echo "Not in Top21" >&2
	        exit 0
	fi

fi

if [[ $1 == "bos42" ]]; then

	 # Check if eos42freedom is in top21
     BP=$($BLEOS system listproducers -j -l 21 | jq ".rows[].owner" | grep -c eos42freedom) 


    if [ $BP -gt 0 ];
		then
	        OLD=$(<$FILEEOS42)
	        echo "Old unpaid_blocks: $OLD"
	        UNPAID="$(/bin/bash $CLEOS get table eosio eosio producers -l 150 | /bin/grep -A 6 "eos42freedom" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
	        echo $UNPAID > $FILEEOS42

	        if [[ $UNPAID -eq $OLD ]];
	        then
	          echo "Not Producing"
	          exit 2
	        else
	          echo "Successfully Producing" >&2
	          exit 0
	        fi
	    else
            echo "Not in Top21" >&2
	        exit 0
	fi
fi

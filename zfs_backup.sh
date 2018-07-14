#!/bin/bash 

# Set the PAST time to check against
PAST=$(date -d "2 hours ago" +'%Y%m%d%H')

# Get timestamp of last backup for comparison
LAST_BACKUP=$(sudo zfs list -t snapshot | tail -1 | cut -d' ' -f1 | cut -d'@' -f2)


if [ $PAST -gt $LAST_BACKUP ]; then
        echo "ZFS Snapshots have stopped working"
        exit 2
else
        echo "Last ZFS snapshot ${LAST_BACKUP}."
        exit 0
fi

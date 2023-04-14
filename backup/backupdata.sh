#!/bin/bash
#
# backup important data files 
#

HOSTADDRESS="172.30.2.99"
ERRORFILE="/var/tmp/psqlerror.err"
DAY="`date +'%Y-%m-%d'`"
MONTH="`date +'%Y-%m'`"
SHAREFOLDER="/mnt/backup"
BACKUPDIR="$SHAREFOLDER/data"
PERIOD="daily"
DIRECTORIES="/etc/smgs /opt/smgs /opt/mobibank /opt/scripts/backup/logs"

# Create mount directory
if [[ ! -d $SHAREFOLDER ]]; then
        mkdir -p $SHAREFOLDE
fi

# Welcome
echo "Backup script started $0"
echo "Today: `date +"%Y-%m-%d %M:%S"`"

# Check mount disk
mount.cifs //172.28.80.30/base $SHAREFOLDER -o username=backup30,password=backup30 2>$ERRORFILE
if [[ $? != 0 ]]; then
        echo "Error: Failed to mount shared disk, backup process stopped!"
        exit 4
fi
echo "Shared folder is mounted successfully."

# Create databases folder
if [[ ! -d $BACKUPDIR ]]; then
        mkdir -p $BACKUPDIR
fi
 
# Backup database
echo -n "Starting Backup data... " 
if [[ $PERIOD = "daily" ]];then
tar czPf $BACKUPDIR/$HOSTNAME-datafs-$DAY.tgz $DIRECTORIES
#elif [[ $PERIOD = "monthly" ]]; then
fi

if [[ $? != 0 ]]; then
        echo "ERROR"
else
        echo "OK"
fi
# Unmount shared folder
umount -f /mnt/backup 2>$ERRORFILE
if [[ $? != 0 ]]; then
        echo "Error: Failed to unmount shared folder."
        exit 
fi
echo "Shared folder is unmounted successfully."


# Clean files and temp folders
rm -f $ERRORFILE

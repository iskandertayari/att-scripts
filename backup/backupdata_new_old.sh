#!/bin/bash
#
# backup database 
#

HOSTADDRESS="172.30.2.99"
DATABASE="smgs"
USER="smgs"
PASSWORD=""
ERRORFILE="/var/tmp/psqlerror.err"
DAY="`date +'%Y-%m-%d'`"
MONTH="`date +'%Y-%m'`"
SHAREFOLDER="/mnt/backup"
BACKUPDIR="$SHAREFOLDER/databases"
PERIOD="monthly"

# Welcome
echo "Backup script started $0" 
echo "Today: `date`"

# Test database connection
TEMP="`psql -h $HOSTADDRESS -U $USER -l 2>$ERRORFILE`"

if [[ -n `cat $ERRORFILE |grep 'Connection refused'` ]] ; then
        echo "Error: Failed to connect to $HOSTADDRESS"
        exit 1
fi

if [[ -n `cat $ERRORFILE |grep 'FATAL:  role'` ]]; then
        echo "Error: User '$USER' does not exist"
        exit 2
fi

unset TEMP

TEMP="`psql -h $HOSTADDRESS -U $USER -l | awk '{print $1}' |grep -w $DATABASE`"

if [[ -z $TEMP ]]; then
        echo "Error: Database '$DATABASE' does not exist"
        exit 3
fi

# Create mount directory
if [[ ! -d $SHAREFOLDER ]]; then
        mkdir -p $SHAREFOLDE
fi

if grep -qs $SHAREFOLDER /proc/mounts; then
    echo "Shared folder already mounted."
else
    echo "Shared folder not mounted, mounting it."
    mount.cifs //172.28.80.30/base $SHAREFOLDER -o username=backup30,password=backup30
    if [[ $? != 0 ]]; then
        echo "Error: Failed to mount shared disk, backup process stopped!"
        exit 4
    fi
    echo "Shared folder is mounted successfully."
fi

# Create databases folder
if [[ ! -d $BACKUPDIR ]]; then
        mkdir -p $BACKUPDIR
fi
 
# Backup database
echo -n "Starting Backup '$DATABASE' ... " 
if [[ $PERIOD = "daily" ]];then
pg_dump -h $HOSTADDRESS -U $USER $DATABASE 2>$ERRORFILE | gzip > $BACKUPDIR/$DATABASE-$DAY.gz 2>$ERRORFILE
elif [[ $PERIOD = "monthly" ]]; then
pg_dump -h $HOSTADDRESS -U $USER $DATABASE 2>$ERRORFILE | gzip > $BACKUPDIR/$DATABASE-$MONTH.gz 2>$ERRORFILE
fi

if [[ $? != 0 ]]; then
        echo "ERROR"
else
        echo "OK"
fi
# Unmount shared folder
umount /mnt/backup 2>$ERRORFILE
if [[ $? != 0 ]]; then
        echo "Error: Failed to unmount shared folder."
        exit 
fi
echo "Shared folder is unmounted successfully."

echo "Backup script ended: `date`"
# Clean files and temp folders
rm -f $ERRORFILE
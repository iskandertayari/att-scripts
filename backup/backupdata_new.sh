#!/bin/bash
#
# backup important data files 
#

HOSTADDRESS="172.30.2.198"
ERRORFILE="/var/tmp/backup_script.err"
DAY="`date +'%Y-%m-%d'`"
MONTH="`date +'%Y-%m'`"
SHAREFOLDER="/mnt/backup"
BACKUPDIR="$SHAREFOLDER/data"
PERIOD="daily"
DIRECTORIES="/var/log/smgs-httpapi/ /var/log/tomcat/ /opt/SMGS/tomcat/log/ /var/log/nginx /var/log/munin /var/log/cassandra/ /var/log/jboss /var/log/cron /var/log/maillog
/var/log/messages/ /opt/SMGS/postgres/data/pg_log/ /opt/SMGS/postgres/data /opt/scripts/backup/logs"

# Create mount directory
if [[ ! -d $SHAREFOLDER ]]; then
        mkdir -p $SHAREFOLDE
fi

# Welcome
echo "Backup script started $0"
echo "Today: `date +"%Y-%m-%d %M:%S"`"

# Check mount disk
mount.cifs //172.30.2.198/base $SHAREFOLDER -o username=root,password=tRitux2014 2>$ERRORFILE
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
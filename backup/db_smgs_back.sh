#!/bin/bash

# A simple script to perform postgres db backup.

DATE=$(date +"%Y%m%d%H%M")
PGPATH=/usr/
HOSTNAME=postgres-db
USERNAME=smgs
PASSWORD=tritux
DATABASE=smgs_dev
ERRORFILE="/home/postgres_backups/back_err.log"
cd /home/postgres_backups

# TODO : Update your servername, username and database names

export PGPASSWORD="$PASSWORD"

$PGPATH/bin/pg_dump -F t -h $HOSTNAME -U $USERNAME $DATABASE > smgs_dev_${DATE}.tar

unset PGPASSWORD

gzip smgs_dev_${DATE}.tar

# Cleanup configuration backups older than 30 days. 
#You can comment or adjust this if you donot want to delete old backups.

find /home/postgres_backups -type f -mtime +6 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/home/backup/SMGS_DB > $ERRORFILE 2>&1

find /home/postgres_backups -name "smgs_dev*.gz" -mtime +7 -type f -delete



#tar xzPf
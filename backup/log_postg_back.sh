#!/bin/bash

# A simple script to perform postgres db backup.

DATE=$(date +"%Y%m%d")
PGPATH="/opt/SMGS/postgres/data/pg_log"
ERRORFILE="/home/postgres_backups/back_err.log"

echo -e "LOG Backup script started $0"
echo "Today: `date`"
echo -e "Starting Backup data... " 



cd $PGPATH
tar -czvf postgresql-Fri.$DATE.tar.gz  postgresql-Fri.log > $ERRORFILE 2>&1
tar -czvf postgresql-Mon.$DATE.tar.gz  postgresql-Mon.log >> $ERRORFILE 2>&1
tar -czvf postgresql-Sat.$DATE.tar.gz  postgresql-Sat.log >> $ERRORFILE 2>&1
tar -czvf postgresql-Sun.$DATE.tar.gz  postgresql-Sun.log >> $ERRORFILE 2>&1
tar -czvf postgresql-Thu.$DATE.tar.gz  postgresql-Thu.log >> $ERRORFILE 2>&1
tar -czvf postgresql-Tue.$DATE.tar.gz  postgresql-Tue.log >> $ERRORFILE 2>&1
tar -czvf postgresql-wed.$DATE.tar.gz  postgresql-Wed.log >> $ERRORFILE 2>&1


find $PGPATH -name "postgresql*.gz" -type f -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/home/backup/SMGS_DB >> $ERRORFILE 2>&1

find $PGPATH -name "postgresql*.gz" -type f -delete

echo "Backup script ended: `date`"

if [[ $? != 0 ]]; then
        echo -e "ERROR, cantact Tritux Team to resolve IT"
else
        echo -e "Everything is Okayy :D"
fi
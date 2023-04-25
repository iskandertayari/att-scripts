#!/bin/bash
# backup important data files 

HOSTADDRESS="172.30.2.198"
ERRORFILE="/var/tmp/backup_script.err"
DAY="`date +'%Y-%m-%d'`"
MONTH="`date +'%Y-%m'`"
PERIOD="daily"
MUNIN="/var/log/munin"
CASSANDRA="/opt/SMGS/cassandra/apache-cassandra-2.2.4/logs"
JBOSS="/var/log/jboss"
JBOSS_cdr="/opt/SMGS/jboss/server/smgs/log"
KANNEL="/var/log/smgs-httpapi"
NGINX="/var/log/nginx"
SMGS="/opt/SMGS"
SYSLOG_cron="/var/log/cron"
SYSLOG_secure="/var/log/secure"
SYSLOG_maillog="/var/log/maillog"
SYSLOG_messages="/var/log/messages"
SYSLOG_spooler="/var/log/spooler"
TOMCAT1="/opt/SMGS/tomcat/log"
TOMCAT2="/opt/SMGS/tomcat/logs"

# Welcome
echo -e "Backup script started $0"
echo "Today: `date`"

# Check mount disk
#mount.cifs //172.30.2.198/base $SHAREFOLDER -o username=root,password=tRitux2014 2>$ERRORFILE
echo -e "Starting Backup data... " 

# Munin
echo -e "Munin bakcup..."
find $MUNIN -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/MUNIN/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: Munin backup failed , backup process stopped!"
else
echo -e "Munin bakcup was successfully done."
fi

# Kannel
echo -e "Kannel bakcup..."
find $KANNEL -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/KANNEL/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: Kannel backup failed , backup process stopped!"
else
echo -e "Kannel bakcup was successfully done."
fi

# Tomcat
echo -e "Tomcat bakcup..."
find $TOMCAT1 -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/TOMCAT/log/ > $ERRORFILE 2>&1
find $TOMCAT2 -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/TOMCAT/logs/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: TOMCAT backup failed , backup process stopped!"
else
echo -e "TOMCAT bakcup was successfully done."
fi

# Nginx
echo -e "Nginx bakcup..."
find $NGINX -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/NGINX/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: NGINX backup failed , backup process stopped!"
else
echo -e "NGINX bakcup was successfully done."
fi

# CASSANDRA
echo -e "CASSANDRA bakcup..."
find $CASSANDRA -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/CASSANDRA/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: CASSANDRA backup failed , backup process stopped!"
else
echo -e "CASSANDRA bakcup was successfully done."
fi

# JBOSS
echo -e "JBOSS bakcup..."
find $JBOSS -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/JBOSS/server_log_2023 > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: JBOSS backup failed , backup process stopped!"
else
echo -e "JBOSS bakcup was successfully done."
fi

# JBOSS CDR
echo -e "JBOSS CDR bakcup..." 
find $JBOSS_cdr -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/JBOSS/cdr_log_2023 > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: JBOSS CDR backup failed , backup process stopped!"
else
echo -e "JBOSS CDR bakcup was successfully done."
fi

#SYSLOG
echo -e "SYSLOG bakcup..." 
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SYSLOG_maillog root@172.30.2.198:/base/SMGS-APP/SYSLOG/maillog > $ERRORFILE 2>&1
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SYSLOG_cron root@172.30.2.198:/base/SMGS-APP/SYSLOG/cron > $ERRORFILE 2>&1
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SYSLOG_messages root@172.30.2.198:/base/SMGS-APP/SYSLOG/messages > $ERRORFILE 2>&1
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SYSLOG_secure root@172.30.2.198:/base/SMGS-APP/SYSLOG/secure > $ERRORFILE 2>&1
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SYSLOG_spooler root@172.30.2.198:/base/SMGS-APP/SYSLOG/spooler > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: SYSLOG backup failed , backup process stopped!"
else
echo -e "SYSLOG bakcup was successfully done."
fi

#SMGS APPDATA
echo -e "SMGS APPDATA bakcup..." 
sshpass -p 'tRitux2014' rsync -av -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" $SMGS root@172.30.2.198:/home/backup/SMGS > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: SMGS backup failed , backup process stopped!"
else
echo -e "SMGS bakcup was successfully done."
fi

echo "Backup script ended: `date`"

if [[ $? != 0 ]]; then
        echo -e "ERROR, cantact Tritux Team to resolve IT"
else
        echo -e "Everything is Okayy :D"
fi
#!/bin/bash
#
# backup important data files 

HOSTADDRESS="172.30.2.198"
ERRORFILE="/var/tmp/backup_script.err"
DAY="`date +'%Y-%m-%d'`"
MONTH="`date +'%Y-%m'`"
PERIOD="daily"
MUNIN="/var/log/munin"
CASSANDRA="/opt/SMGS/cassandra/apache-cassandra-2.2.4/logs"
JBOSS="/var/log/jboss"
KANNEL="/var/log/smgs-httpapi"
NGINX="/var/log/nginx"
SMGS=""
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
find $MUNIN -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/MUNIN/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: Munin backup failed , backup process stopped!"
else
echo -e "Munin is bakcuped successfully."
fi

# Kannel
find $KANNEL -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/KANNEL/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: Kannel backup failed , backup process stopped!"
else
echo -e "Kannel is bakcuped successfully."
fi

# Tomcat
find $TOMCAT1 -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/TOMCAT/log/ > $ERRORFILE 2>&1
find $TOMCAT2 -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/TOMCAT/logs/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: TOMCAT backup failed , backup process stopped!"
else
echo -e "TOMCAT is bakcuped successfully."
fi

# Nginx
find $NGINX -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/NGINX/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: NGINX backup failed , backup process stopped!"
else
echo -e "NGINX is bakcuped successfully."
fi

# CASSANDRA
find $CASSANDRA -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/CASSANDRA/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: CASSANDRA backup failed , backup process stopped!"
else
echo -e "CASSANDRA is bakcuped successfully."
fi

# JBOSS
find $JBOSS -type f -mtime +30 -print0 | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/JBOSS/ > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: JBOSS backup failed , backup process stopped!"
else
echo -e "JBOSS is bakcuped successfully."
fi

#SYSLOG
find $SYSLOG_maillog -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/maillog > $ERRORFILE 2>&1
find $SYSLOG_cron -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/cron > $ERRORFILE 2>&1
find $SYSLOG_messages -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/messages > $ERRORFILE 2>&1
find $SYSLOG_secure -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/secure > $ERRORFILE 2>&1
find $SYSLOG_spooler -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/spooler > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: SYSLOG backup failed , backup process stopped!"
else
echo -e "SYSLOG is bakcuped successfully."
fi

#SMGS APPDATA
find $SYSLOG_maillog -type f | xargs -0 -I {} sshpass -p 'tRitux2014' rsync -avz -e "ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" {} root@172.30.2.198:/base/SMGS-APP/SYSLOG/maillog > $ERRORFILE 2>&1
if [[ $? != 0 ]]; then
        echo -e "Error: SYSLOG backup failed , backup process stopped!"
else
echo -e "SYSLOG is bakcuped successfully."
fi

echo "Backup script ended: `date`"

if [[ $? != 0 ]]; then
        echo -e "ERROR"
else
        echo -e "OK"
fi


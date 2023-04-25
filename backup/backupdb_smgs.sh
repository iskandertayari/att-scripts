#!/bin/bash
#
# Database backup script 
#

HOSTADDRESS="172.30.2.99"
DATABASE="smgs"
USER="smgs"
PASSWORD=""
ERRORFILE="/var/tmp/psqlerror.err"
DAY="$(date +'%Y-%m-%d')"
MONTH="$(date +'%Y-%m')"
SHAREFOLDER="/mnt/backup"
BACKUPDIR="$SHAREFOLDER/databases"
PERIOD="monthly"

# Welcome message
echo "Starting database backup script: $0" 
echo "Current time: $(date +"%Y-%m-%d %M:%S")"

# Test database connection
if ! psql -h "$HOSTADDRESS" -U "$USER" -c "select 1" >/dev/null 2>"$ERRORFILE"; then
        echo "Error: Failed to connect to database."
        exit 1
fi

# Check if database exists
if ! psql -h "$HOSTADDRESS" -U "$USER" -lqt | cut -d \| -f 1 | grep -qw "$DATABASE"; then
        echo "Error: Database '$DATABASE' does not exist."
        exit 2
fi

# Create backup directory if it doesn't exist
if [[ ! -d "$BACKUPDIR" ]]; then
        mkdir -p "$BACKUPDIR"
fi

# Mount shared folder if not already mounted
if ! grep -qs "$SHAREFOLDER" /proc/mounts; then
    echo "Shared folder not mounted, attempting to mount..."
    if ! mount.cifs "//172.28.80.30/base" "$SHAREFOLDER" -o "username=backup30,password=backup30"; then
        echo "Error: Failed to mount shared disk."
        exit 3
    fi
    echo "Shared folder is mounted successfully."
else
    echo "Shared folder already mounted."
fi

# Backup database
echo -n "Starting backup of '$DATABASE'..."
if [[ "$PERIOD" = "daily" ]]; then
    pg_dump -h "$HOSTADDRESS" -U "$USER" "$DATABASE" | gzip > "$BACKUPDIR/$DATABASE-$DAY.gz" 2>"$ERRORFILE"
else
    pg_dump -h "$HOSTADDRESS" -U "$USER" "$DATABASE" | gzip > "$BACKUPDIR/$DATABASE-$MONTH.gz" 2>"$ERRORFILE"
fi

if [[ $? -ne 0 ]]; then
        echo "ERROR"
else
        echo "OK"
fi

# Unmount shared folder
if ! umount "$SHAREFOLDER"; then
        echo "Error: Failed to unmount shared folder."
        exit 4
fi
echo "Shared folder is unmounted successfully."

# Clean up files and temp folders
rm -f "$ERRORFILE"

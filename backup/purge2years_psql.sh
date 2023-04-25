#!/bin/bash
# Author:       Hamed Abdelli <hamed.abdelli@tritux.com>
# Date:         2015220
# Script name:  purge2years.sh
# Description:  Purge 2 years old records into CSV file
#

# Database settings
DBNAME="monitoring_sms"
DBUSER="monitoring_sms"
DBPASS="monitoring"
DBHOST="172.30.2.198"

OUTPUT_PATH="/opt/backup"

DATE_TABLES=(stats stats_map) # Tables using Date format
EPOCH_TABLES=(sms_mobibank_mo sms_mobibank_mt sms_smgs) # Tables using UNIX timestamp as date

PSQLCMD="/usr/bin/psql -U $DBUSER -h $DBHOST $DBNAME"

DATE=`date -d '2 years ago 1 day ago' +%F`

export PGPASSWORD=$DBPASS

echo "`date +"%F %T"` - Purge start"

# Extract old data and delete
for i in ${DATE_TABLES[*]};
do
        DST_FILE="$OUTPUT_PATH/$i-$DATE".csv
        # Extract
        echo "`date +"%F %T"` - Copying from $i"
        echo "COPY ( SELECT * FROM $i WHERE date_stats < NOW() - INTERVAL '2 years' )
        TO STDOUT WITH CSV HEADER" \
        | $PSQLCMD > "$DST_FILE"
        # Delete
        echo "`date +"%F %T"` - Deleting from $i"
        echo "DELETE FROM $i WHERE date_stats < NOW() - INTERVAL '2 years'" | $PSQLCMD
done

for i in ${EPOCH_TABLES[*]};
do
        if [ $i = "sms_smgs" ]; then
                FIELD=timecreated
        else
                FIELD=created_at
        fi

        DST_FILE="$OUTPUT_PATH/$i-$DATE".csv

        # Extract
        echo "`date +"%F %T"` - Copying from $i"
        echo "COPY ( SELECT * FROM $i WHERE TO_TIMESTAMP($FIELD) < NOW() - INTERVAL '2 years' )
        TO STDOUT WITH CSV HEADER" \
        | $PSQLCMD > "$DST_FILE"

        echo "`date +"%F %T"` - Deleting from $i"
        # Delete
        echo "DELETE FROM $i WHERE TO_TIMESTAMP($FIELD) < NOW() - INTERVAL '2 years'" | $PSQLCMD
done
echo -e "`date +"%F %T"` - Purge end\n------------\n"
#!/bin/bash
#restore database
set -e

DB={{db_to_backup}}
SQLUSERNAME={{sql_username}}
SQLPASSWORD={{sql_password}}
DB_BACKUP={{db_backup_name}}
AWS="$(which aws)"
GPG="$(which gpg)"
MYSQL="$(which mysql)"
Q1="CREATE DATABASE IF NOT EXISTS $DB_BACKUP;"
#Get latest backup from s3
LATESTBACKUP="$(aws s3 ls {{s3_website_domain}} | sort | grep {{db_to_backup}}* | tail -n 1 | awk '{print $4}')"
TARBACKUP="$(echo $LATESTBACKUP | sed 's/.gpg//g')"
DUMP="$(echo $TARBACKUP | sed 's/.gz//g')"

$AWS s3 cp s3://{{s3_website_domain}}/$LATESTBACKUP /home/ubuntu/
$GPG -o /home/ubuntu/$TARBACKUP --passphrase {{encryption_password}} -d $LATESTBACKUP
gunzip /home/ubuntu/$TARBACKUP

$MYSQL -u $SQLUSERNAME -p"${SQLPASSWORD}" -e "${Q1}" #create backup db

$MYSQL -u $SQLUSERNAME -p"${SQLPASSWORD}" $DB_BACKUP < /home/ubuntu/$DUMP #restore database

COMPARE=$?
if [ $COMPARE -eq 0 ]; then  
  rm -rf /home/ubuntu/*.sql*
  echo "success"
else
	rm -rf /home/ubuntu/*.sql*
	echo "fail"
	exit 1
fi
echo "finished script..."
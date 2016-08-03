#!/bin/bash
#backup of important data
set -ex

echo "starting script..."
TIME=`date +%b-%d-%y`            # get date to add to file name
FILENAME=backup-$TIME.tar.gz    # define backup name format.
SRCDIR=/etc                    #foler to backup.
DESDIR=/home/ubuntu/sysbackup    # destination of backup

echo "marking tar"
tar -cpzf $DESDIR/$FILENAME $SRCDIR #backup srcdir to desdir/filename
echo "moving backup to aws s3"
{{aws_path.stdout}} s3 mv $DESDIR/ s3://{{s3_website_domain}}/ --recursive #push desdir/filename to aws s3 bucket

{{automysqlbackup_path.stdout}} /etc/default/automysqlbackup

{{aws_path.stdout}} s3 mv /var/lib/automysqlbackup/daily/ s3://{{s3_website_domain}}/ --recursive

echo "finished script..."

# backup_restore

setup daily backups with AWS S3 bucket for your mysql databases and configuration files for ubuntu 14

Clone this repo: 

```git clone https://github.com/andela-oolarewaju/backup_restore.git ```

Then:

```$ cd backup_restore```

Create a ```vars.yml``` file and put the following credentials and variables like:

```
aws_access_key_id: ""
aws_secret_access_key: ""
region: ""
output: ""
s3_website_domain: ""
folder_to_backup: ""
db_to_backup: ""
sql_username: ""
sql_password: ""
db_backup_name: ""
encryption_password: "" #password to use to encrypt and decrypt backup (do not forget this)
aws_user_arn: ""  #12345544444:user/yourusername
s3_bucket_policy: |
  {
    "Version": "2012-10-17",
    "Id": "PutObjPolicy",
    "Statement": [
      {
        "Sid": "DenyIncorrectEncryptionHeader",
        "Effect": "Allow",
        "Principal": {"AWS": "arn:aws:iam::{{ aws_user_arn }}"},
        "Action": "*",
        "Resource": "arn:aws:s3:::{{s3_website_domain}}/*"
      }
    ]
  }

#Cron job time to run backups:

min: "" #minute of the hour 
hr: "" #hour of the day
dom: "" #day of the month
mon: "" #month
dow: "" #day of the week

```

This file **SHOULD NOT** be public

Look in the ```roles/backup_push/templates/backup``` and  ```roles/confirm_backup/templates/confirm_backup``` to 

change your daily backup time.

Fill in your machine's public ip address and the path to your private key in the ```inventory.ini``` file

**RUN** `ansible-playbook -i inventory.ini playbook.main.yml`

**TO TEST**
cd into features/install.steps.rb

Fill in the variable values in the install.steps.rb file. example:
```
PATHTOPRIVATEKEY = "/path/to/private/key"
PUBDNS = "" #example ubuntu@ec2-11-22-33-44.compute-1.amazonaws.com
BUCKETNAME = "" #awsbucketname
```

**Then RUN** cucumber featuers/install.feature
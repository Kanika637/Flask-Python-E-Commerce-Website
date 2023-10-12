#!/bin/bash


MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_DB="sample-db"


S3_BUCKET="mongodb-db-backup-bucket"
S3_FOLDER="mongodb-backups"


TIMESTAMP=$(date +%Y%m%d%H%M%S)


BACKUP_DIR="/tmp/mongodb-backup-$TIMESTAMP"


mkdir -p $BACKUP_DIR


mongodump --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB --out $BACKUP_DIR


tar -zcvf $BACKUP_DIR.tar.gz $BACKUP_DIR


aws s3 cp $BACKUP_DIR.tar.gz s3://$S3_BUCKET/$S3_FOLDER/$TIMESTAMP-mongodb-backup.tar.gz


rm -r $BACKUP_DIR
rm $BACKUP_DIR.tar.gz

echo "Backup completed and uploaded to S3."

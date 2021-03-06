#!/bin/bash

### export credentials
export CB_REST_USERNAME=''
export CB_REST_PASSWORD=''
export prd_bucket=''


## run script as a sudoer
set -e

export PATH=/opt/couchbase/bin:$PATH

rm -rf /tmp/backup_migrate
mkdir /tmp/backup_migrate

# config backup folder
cbbackupmgr config -a /tmp/backup_migrate -r cluster --disable-data

# backup the cluster
cbbackupmgr backup -c 127.0.0.1 -u $CB_REST_USERNAME -p $CB_REST_PASSWORD -a /tmp/backup_migrate -r cluster
# make a placeholder file so gsutil rm won't return error on empty bucket
touch /tmp/backup_migrate/placeholder.txt

# remove older backup, and upload the new one
# put a file in cloud storage bucket before the first run so rm command won't error out
# gsutil rm gs://$prd_bucket/**
gsutil -m cp -r /tmp/backup_migrate/cluster gs://$prd_bucket
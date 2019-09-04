#!/bin/bash

take_snapshot(){
  # take snapshot
  curl -vs -X PUT "$ES_BASE_URL/_snapshot/$ES_SNAPSHOT_REPO/$1?wait_for_completion=true"
  # compress backup to be able to move to other location
  cd $BACKUP_DIR
  sudo tar -cvzf ~/$SNAPSHOT_NAME.tar.gz *
}

_main(){
  ES_HOST="localhost"
  ES_PORT=9200
  ES_BASE_URL=$ES_HOST:$ES_PORT

  BACKUP_DIR="/mnt/es_backup"
  ES_SNAPSHOT_REPO="es_backup"

  date_now=`date +%Y%m%d%H%M%S`
  # snapshot is created with today's date
  SNAPSHOT_NAME=snapshot_$date_now
  # change $SNAPSHOT_NAME with name you wish to give to snapshot
  take_snapshot $SNAPSHOT_NAME
}

_main

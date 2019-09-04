#!/bin/bash

restore_indices(){
  # restore indices
  curl -X POST "$ES_BASE_URL/_snapshot/$ES_SNAPSHOT_REPO/$SNAPSHOT_NAME/_restore"
}
move_backup(){
  # extract backup to backup directory
  tar -xvzf $TAR_FILE -C $BACKUP_DIR

  # change permissions
  sudo chown -R $ES_USER:$ES_USER $BACKUP_DIR
}
_main(){
  ES_HOST="localhost"
  ES_PORT=9200
  ES_BASE_URL=$ES_HOST:$ES_PORT

  BACKUP_DIR="/mnt/es_backup"
  ES_SNAPSHOT_REPO="es_backup"
  ES_USER="elasticsearch"

  # replace below variables with your .tar.gz filename and snapshot name 
  TAR_FILE="20190904.tar.gz"
  SNAPSHOT_NAME="20190904"

  move_backup
  restore_indices
}

_main

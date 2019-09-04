#!/bin/bash
# timer
countdown(){
  for (( i=$1; i>0; i--)); do
    sleep 1 &
    printf "  $i \r"
    wait
  done
}

configure_es_backup(){
  # create backup directory
  sudo mkdir -p $BACKUP_DIR
  # change permissions, backup directory must be owned by elasticsearch user
  sudo chown -R $ES_USER:$ES_USER $BACKUP_DIR
  # add path.repo to elasticsearch configuration file
  sudo sed -i "s|path.repo|#path.repo|g" $ES_CONFIG_FILE
  echo "path.repo: [\"$BACKUP_DIR\"]" | sudo tee -a $ES_CONFIG_FILE
  # restart elasticsearch to enable changes made
  sudo service elasticsearch restart
  sudo service elasticsearch status
}


register_snapshot_repo(){
  curl -X PUT "$ES_BASE_URL/_snapshot/$ES_SNAPSHOT_REPO" -H 'Content-Type: application/json' -d "{\"type\": \"fs\", \"settings\": {\"location\": \"$BACKUP_DIR\", \"compress\": true } }"
}

_main(){
  ES_HOST="localhost"
  ES_USER=elasticsearch
  ES_PORT=9200

  BACKUP_DIR="/mnt/es_backup"
  ES_CONFIG_FILE="/etc/elasticsearch/elasticsearch.yml"
  ES_SNAPSHOT_REPO="es_backup"

  ES_BASE_URL=$ES_HOST:$ES_PORT

  # configuration to enable backup/snapshot
  configure_es_backup
  # wait for 15 seconds, elasticsearch may take time to start
  countdown 15
  # register snapshot repository
  register_snapshot_repo

  # check if elasticsearch is up and running
  curl $ES_HOST:$ES_PORT
}

_main

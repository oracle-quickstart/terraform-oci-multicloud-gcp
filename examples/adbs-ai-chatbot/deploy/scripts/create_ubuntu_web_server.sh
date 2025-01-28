#!/bin/bash

# Create Ubuntu Web Server
log_message "Creating Ubuntu Web Server..."
UBUNTU_WEB_SERVER_ID=$(gcloud compute instances create $WEB_SERVER --zone=$REGION-a --machine-type=e2-medium --subnet=$PUBLIC_SUBNET --network-tier=PREMIUM --maintenance-policy=MIGRATE --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=ubuntu-web-server --no-shielded-secure-boot --shielded-vtpm --tags=http-server,bastion --format='get(id)' || { log_message "Failed to create Ubuntu Web Server"; exit 1; })
echo "Ubuntu Web Server Name: ubuntu-web-server" >> $LOG_FILE
echo "Ubuntu Web Server ID: $UBUNTU_WEB_SERVER_ID" >> $LOG_FILE
log_message "Ubuntu Web Server created successfully."
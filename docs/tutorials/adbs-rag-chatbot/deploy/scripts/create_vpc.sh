#!/bin/bash

# Create VPC
log_message "Creating VPC..."
VPC_ID=$(gcloud compute networks create $VPC_NAME --subnet-mode=custom --format='get(id)' || { log_message "Failed to create VPC"; exit 1; })
echo "VPC Name: $VPC_NAME" >> $LOG_FILE
echo "VPC ID: $VPC_ID" >> $LOG_FILE
log_message "VPC created successfully."
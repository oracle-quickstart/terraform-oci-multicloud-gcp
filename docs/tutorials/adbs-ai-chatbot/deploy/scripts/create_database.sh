#!/bin/bash

# Create database
log_message "Creating database..."
DATABASE_ID=$(gcloud oracle-database autonomous-databases create $DATABASE_DISPLAY_NAME --location=$REGION --display-name=$DATABASE_DISPLAY_NAME --database=$DATABASE_NAME --network=$VPC_NAME --cidr=192.168.0.0/24 --admin-password=$ADMIN_PASSWORD --properties-compute-count=2 --properties-data-storage-size-gb=500 --properties-db-version=23ai --properties-license-type=LICENSE_INCLUDED --properties-db-workload=OLTP --format='get(id)' || { log_message "Failed to create database"; exit 1; })
echo "Database Name: $DATABASE_DISPLAY_NAME" >> $LOG_FILE
echo "Database ID: $DATABASE_ID" >> $LOG_FILE
log_message "Database created successfully."
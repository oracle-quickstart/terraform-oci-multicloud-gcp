#!/bin/bash

# Create Windows VM
log_message "Creating Windows VM..."
WINDOWS_VM_ID=$(gcloud compute instances create quickstart-winvm --image-family windows-2022 --image-project windows-cloud --machine-type e2-standard-4 --zone $REGION-a --network $VPC_NAME --network-tier=PREMIUM --subnet $(gcloud compute networks subnets describe public-subnet1 --region $REGION --format='get(selfLink)') --boot-disk-size 50GB --boot-disk-type pd-ssd --enable-display-device --tags=bastion --format='get(id)' || { log_message "Failed to create Windows VM"; exit 1; })
echo "Windows VM Name: quickstart-winvm" >> $LOG_FILE
echo "Windows VM ID: $WINDOWS_VM_ID" >> $LOG_FILE
log_message "Windows VM created successfully."

# Describe Windows VM
log_message "Describing Windows VM..."
gcloud compute instances describe quickstart-winvm --zone=$REGION-a --format='get(name,networkInterfaces[0].accessConfigs[0].natIP)' || { log_message "Failed to describe Windows VM"; exit 1; }
log_message "Windows VM described successfully."

# Retry resetting Windows password with exponential backoff
max_attempts=2
attempt=0
while [ $attempt -lt $max_attempts ]; do
  log_message "Attempting to reset Windows password (attempt ${attempt+1}/${max_attempts})..."
  if gcloud compute reset-windows-password quickstart-winvm --zone=$REGION-a; then
    log_message "Windows password reset successfully."
    break
  else
    log_message "Failed to reset Windows password. Retrying in 5 seconds..."
    sleep 5
    ((attempt++))
  fi
done

if [ $attempt -eq $max_attempts ]; then
  log_message "Failed to reset Windows password after ${max_attempts} attempts."
  exit 1
fi
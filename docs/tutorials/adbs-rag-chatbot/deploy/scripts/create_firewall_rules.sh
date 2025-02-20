#!/bin/bash

# Create firewall rules
log_message "Creating firewall rules..."
INGRESS_RULE_ID=$(gcloud compute firewall-rules create $INGRESS_RULE --direction=INGRESS --priority=1000 --network=$VPC_NAME --action=ALLOW --rules=tcp:22,tcp:80,tcp:443,tcp:1522,tcp:3389 --source-ranges=0.0.0.0/0 --description="Allow SSH, HTTP, HTTPS, Autonomous DB, and RDP access" --target-tags=http-server,bastion --format='get(id)' || { log_message "Failed to create ingress firewall rule"; exit 1; })
echo "Ingress Firewall Rule Name: allow-common-ports" >> $LOG_FILE
echo "Ingress Firewall Rule ID: $INGRESS_RULE_ID" >> $LOG_FILE
EGRESS_RULE_ID=$(gcloud compute firewall-rules create $EGRESS_RULE --direction=EGRESS --priority=1000 --network=$VPC_NAME --action=ALLOW --rules=tcp:22,tcp:80,tcp:443,tcp:1522,tcp:3389 --destination-ranges=0.0.0.0/0 --target-tags=http-server,bastion --format='get(id)' || { log_message "Failed to create egress firewall rule"; exit 1; })
echo "Egress Firewall Rule Name: allow-vm-egress" >> $LOG_FILE
echo "Egress Firewall Rule ID: $EGRESS_RULE_ID" >> $LOG_FILE
log_message "Firewall rules created successfully."
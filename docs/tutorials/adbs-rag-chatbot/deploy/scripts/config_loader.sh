#!/bin/bash
pwd
# Load configuration from config.json
CONFIG_FILE="../config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found."
  exit 1
fi

PROJECT_ID=$(jq -r '.project_id' $CONFIG_FILE)
REGION=$(jq -r '.region' $CONFIG_FILE)
VPC_NAME=$(jq -r '.vpc_name' $CONFIG_FILE)
WEB_SERVER=$(jq -r '.web_server_name' $CONFIG_FILE)
ADMIN_PASSWORD=$(jq -r '.admin_password' $CONFIG_FILE)
PUBLIC_SUBNET=$(jq -r '.public_subnet' $CONFIG_FILE)
PRIVATE_SUBNET=$(jq -r '.private_subnet' $CONFIG_FILE)
INGRESS_RULE=$(jq -r '.ingress_rule' $CONFIG_FILE)
EGRESS_RULE=$(jq -r '.egress_rule' $CONFIG_FILE)
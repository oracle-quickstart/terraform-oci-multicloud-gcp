#!/bin/bash

# Write bastion host public IP to bastion_config.json
echo "{\"bastion_host_public_ip\": \"$BASTION_PUBLIC_IP\"}" > bastion_config.json
log_message "Bastion host public IP written to bastion_config.json"
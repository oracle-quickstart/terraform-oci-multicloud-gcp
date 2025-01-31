#!/bin/bash

# Define steps
steps=(
  "Load configuration" "./scripts/config_loader.sh"
  "Ask for database name" "./scripts/ask_for_database_name.sh"
  "Create VPC" "./scripts/create_vpc.sh"
  "Create subnets" "./scripts/create_subnets.sh"
  "Create firewall rules" "./scripts/create_firewall_rules.sh"
  "Create Windows VM" "./scripts/create_windows_vm.sh"
  "Create Ubuntu Web Server" "./scripts/create_ubuntu_web_server.sh"
  "Create database" "./scripts/create_database.sh"
)

for ((i=0; i<${#steps[@]}; i+=2)); do
  echo ""
  echo "-------------------------"
  echo "|  Select Deployment Steps  |"
  echo "-------------------------"
  echo ""
  echo "Do you want to ${steps[i]}? (y/n)"
  read answer
  if [ "$answer" == "y" ]; then
    ${steps[i+1]}
  else
    echo "Skipping ${steps[i]}..."
  fi
done
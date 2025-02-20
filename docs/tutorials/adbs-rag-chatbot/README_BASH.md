# Deploy Oracle Autonomous Database on GCP - bash

To automate the deployment process, we've created a Bash script that guides you through each step. The script is divided into several smaller scripts stored in the deploy/scripts directory, making it easier to manage and maintain individual components.

**TLDR**: With this guide, you'll learn how to:

- Deploy an Autonomous Database on GCP using a Bash script
- Automate the deployment process with minimal user interaction
- Create a VPC, subnets, firewall rules, and instances using the script
- Configure Oracle Autonomous Database on GCP with ease

## Run the script 

- Clone the repo
- Navigate to the deploy directory `cd docs/tutorials/adbs-rag-chatbot/deploy`
- Update copy config json and update it with your config parameters: `cp config.json.txt config.json`

```json
{
  "project_id": "",
  "region": "",
  "vpc_name": "",
  "public_subnet": "",
  "private_subnet": "",
  "ingress_rule": "",
  "egress_rule": "",
  "admin_password": "",
  "web_server_name": "",
  "database_name": "",
  "database_display_name": ""
}
```

- Run bash script in your gcp cli: `./deploy.sh`

## Code walkthrough

```bash
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
```

## Step-by-Step Guide

Let's walk through each step in detail:

### Load Configuration

The first step loads the configuration from a JSON file using the `config_loader.sh` script.

  `./scripts/config_loader.sh`

```JSON
{
  "project_id": "",
  "region": "",
  "vpc_name": "",
  "public_subnet": "",
  "private_subnet": "",
  "ingress_rule": "",
  "egress_rule": "",
  "bastion_name": "",
  "admin_password": "",
  "web_server_name": "",
  "database_name": "",
  "database_display_name": ""
}
```

### Ask for Database Name

The next step asks the user for the database name using the `ask_for_database_name.sh` script.

  `./scripts/ask_for_database_name.sh`

```bash
# Ask user for database name
read -p "Enter the database name (letters only): " DATABASE_NAME

while [[ $DATABASE_NAME =~ [^a-zA-Z] ]]; do
  echo "Invalid input. Please enter a database name containing only letters."
  read -p "Enter the database name (letters only): " DATABASE_NAME
done

DATABASE_DISPLAY_NAME=$DATABASE_NAME
```

### Create a VPC Network

This step creates a VPC using the `create_vpc.sh` script.

  `./scripts/create_vpc.sh`

```bash
# Create VPC
log_message "Creating VPC..."
VPC_ID=$(gcloud compute networks create $VPC_NAME --subnet-mode=custom --format='get(id)' || { log_message "Failed to create VPC"; exit 1; })
echo "VPC Name: $VPC_NAME" >> $LOG_FILE
echo "VPC ID: $VPC_ID" >> $LOG_FILE
log_message "VPC created successfully."
```

### Create Subnets and Firewall Rules

Next, we need to create subnets and firewall rules for our VPC network.

### Create Subnets

This step creates subnets using the `create_subnets.sh` script.

The reason for creating two subnets, one for private IP addresses and one for public IP addresses, is to provide network isolation for different types of traffic. Private subnets are used to host internal resources that do not need to be accessible from the internet, while public subnets are used to host resources that require internet access.

By separating these subnets, it becomes easier to control network traffic and ensure that private resources remain secure and isolated from the public network. Additionally, enabling private IP access for Google Cloud instances ensures that they have a unique IP address within the VPC, which is not visible or accessible from the internet.

  `./scripts/create_subnets.sh`

```bash
# Create subnets
log_message "Creating subnets..."
PRIVATE_SUBNET_ID=$(gcloud compute networks subnets create $PRIVATE_SUBNET --network=$VPC_NAME --region=$REGION --range=192.168.5.0/24 --enable-private-ip-google-access --format='get(id)' || { log_message "Failed to create private subnet"; exit 1; })
echo "Private Subnet Name: private-subnet1" >> $LOG_FILE
echo "Private Subnet ID: $PRIVATE_SUBNET_ID" >> $LOG_FILE
PUBLIC_SUBNET_ID=$(gcloud compute networks subnets create $PUBLIC_SUBNET --network=$VPC_NAME --region=$REGION --range=192.168.4.0/24 --enable-flow-logs --enable-private-ip-google-access --format='get(id)' || { log_message "Failed to create public subnet"; exit 1; })
echo "Public Subnet Name: public-subnet1" >> $LOG_FILE
echo "Public Subnet ID: $PUBLIC_SUBNET_ID" >> $LOG_FILE
log_message "Subnets created successfully."
```

### Create Firewall Rules

The fifth step creates firewall rules using the create_firewall_rules.sh script.

  `./scripts/create_firewall_rules.sh`

Creates two firewall rules: one for incoming traffic (ingress) and another for outgoing traffic (egress). The ingress rule allows SSH, HTTP, HTTPS, Autonomous DB, and RDP access from any source (0.0.0.0/0), while the egress rule allows the same traffic to reach the internet. Both rules are associated with the VPC and have a priority of 1000.

```bash
# Create firewall rules
log_message "Creating firewall rules..."
INGRESS_RULE_ID=$(gcloud compute firewall-rules create $INGRESS_RULE --direction=INGRESS --priority=1000 --network=$VPC_NAME --action=ALLOW --rules=tcp:22,tcp:80,tcp:443,tcp:1522,tcp:3389 --source-ranges=0.0.0.0/0 --description="Allow SSH, HTTP, HTTPS, Autonomous DB, and RDP access" --target-tags=http-server,bastion --format='get(id)' || { log_message "Failed to create ingress firewall rule"; exit 1; })
echo "Ingress Firewall Rule Name: allow-common-ports" >> $LOG_FILE
echo "Ingress Firewall Rule ID: $INGRESS_RULE_ID" >> $LOG_FILE
```  

  The first firewall rule, allow-common-ports, is an ingress rule that allows specific types of traffic from any source (0.0.0.0/0) to reach instances in the VPC. This rule allows SSH, HTTP, HTTPS, Autonomous DB, and RDP access to the VPC. The direction parameter is set to INGRESS, which means that the rule allows traffic coming into the VPC.  

```bash
EGRESS_RULE_ID=$(gcloud compute firewall-rules create $EGRESS_RULE --direction=EGRESS --priority=1000 --network=$VPC_NAME --action=ALLOW --rules=tcp:22,tcp:80,tcp:443,tcp:1522,tcp:3389 --destination-ranges=0.0.0.0/0 --target-tags=http-server,bastion --format='get(id)' || { log_message "Failed to create egress firewall rule"; exit 1; })
echo "Egress Firewall Rule Name: allow-vm-egress" >> $LOG_FILE
echo "Egress Firewall Rule ID: $EGRESS_RULE_ID" >> $LOG_FILE
log_message "Firewall rules created successfully."
```  

  The second firewall rule, allow-vm-egress, is an egress rule that allows specific types of traffic from instances in the VPC to reach the internet. This rule also allows SSH, HTTP, HTTPS, Autonomous DB, and RDP access. The direction parameter is set to EGRESS, which means that the rule allows traffic leaving the VPC.

## Create a Ubuntu and/or Windows VM

Next, I created a webserver host and/or Windows VM.  

### Create Windows VM

The sixth step creates a Windows VM using the `create_windows_vm.sh` script.

Windows VM is a virtual machine that runs the Windows operating system and can be handy if you want access to Oracle APEX User Interface.

  `./scripts/create_windows_vm.sh`

```bash
log_message "Creating Windows VM..."
WINDOWS_VM_ID=$(gcloud compute instances create quickstart-winvm --image-family windows-2022 --image-project windows-cloud --machine-type e2-standard-4 --zone $REGION-a --network $VPC_NAME --network-tier=PREMIUM --subnet $(gcloud compute networks subnets describe public-subnet1 --region $REGION --format='get(selfLink)') --boot-disk-size 50GB --boot-disk-type pd-ssd --enable-display-device --tags=bastion --format='get(id)' || { log_message "Failed to create Windows VM"; exit 1; })
echo "Windows VM Name: quickstart-winvm" >> $LOG_FILE
echo "Windows VM ID: $WINDOWS_VM_ID" >> $LOG_FILE
log_message "Windows VM created successfully."
```

### Create Web Server VM

The seventh step creates an Ubuntu web server using the `create_ubuntu_web_server.sh` script.

  `./scripts/create_ubuntu_web_server.sh`

```bash
# Create Ubuntu Web Server
log_message "Creating Ubuntu Web Server..."
UBUNTU_WEB_SERVER_ID=$(gcloud compute instances create $WEB_SERVER --zone=$REGION-a --machine-type=e2-medium --subnet=$PUBLIC_SUBNET --network-tier=PREMIUM --maintenance-policy=MIGRATE --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=ubuntu-web-server --no-shielded-secure-boot --shielded-vtpm --tags=http-server,bastion --format='get(id)' || { log_message "Failed to create Ubuntu Web Server"; exit 1; })
echo "Ubuntu Web Server Name: ubuntu-web-server" >> $LOG_FILE
echo "Ubuntu Web Server ID: $UBUNTU_WEB_SERVER_ID" >> $LOG_FILE
log_message "Ubuntu Web Server created successfully."
```

### Create Oracle Database@Google Cloud

The final step creates the Oracle Autonomous Database using the `create_database.sh` script.

```bash
# Create database
log_message "Creating database..."
DATABASE_ID=$(gcloud oracle-database autonomous-databases create $DATABASE_DISPLAY_NAME --location=$REGION --display-name=$DATABASE_DISPLAY_NAME --database=$DATABASE_NAME --network=$VPC_NAME --cidr=192.168.0.0/24 --admin-password=$ADMIN_PASSWORD --properties-compute-count=2 --properties-data-storage-size-gb=500 --properties-db-version=23ai --properties-license-type=LICENSE_INCLUDED --properties-db-workload=OLTP --format='get(id)' || { log_message "Failed to create database"; exit 1; })
echo "Database Name: $DATABASE_DISPLAY_NAME" >> $LOG_FILE
echo "Database ID: $DATABASE_ID" >> $LOG_FILE
log_message "Database created successfully."
```

Here is breakdown of the command

- `--location`: select the region where you want database. Please mind here that this services is not availbie in all regions  
  
- `--display-name`: provide a name for your Oracle Autonomous Database  
  
- `--database`: provide a unique name for your Oracle Autonomous Database  
  
- `--network`: select the VPC network ID where you want to run your Oracle Autonomous Database
  
- `--cidr`: select the CIDR block for your subnet where you want to run your Oracle Autonomous Database  
  
- `--admin-password`: provide a strong password for the administrator account of your Oracle Autonomous Database  
  
- `--properties-compute-count=`: specify the number of compute resources to allocate for your Oracle Autonomous Database  
  
- `--properties-data-storage-size-gb`: specify the amount of data storage to allocate for your Oracle Autonomous Database  
  
- `--properties-db-version`: specify the version of Oracle Autonomous Database you want to use
  
- `--properties-license-type`: specify the license type for your Oracle Autonomous Database  
  
- `--properties-db-workload`: specify the workload type for your database (in this example, we are using OLTP)

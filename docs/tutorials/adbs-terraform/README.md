# Provision Autonomous Database @ Google Cloud with Terraform

This tutorial will guide you through provisioning Autonomous Database @ Google Cloud using OCI Multicloud Landing Zone's quickstart template.
You will learn how to deploy the following architecture in pre-configured default settings with minimal mandatory inputs.

![gcp-oci-adbs-quickstart](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp/blob/adbs-ai/images/gcp-oci-adbs-quickstart.png?raw=true)

## Prerequisites and setup

This tutorial has the following prerequisites:

- Google Cloud CLI
- Terraform 1.5.0+
- An existing Google Cloud project

### Verify Google Cloud CLI installation and version

```bash
gcloud -v
```

### Verify Terraform installation and version

```bash
terraform -v
```

### Authenicate to Google Cloud
 
```bash
gcloud auth application-default login
```

```bash
gcloud auth list 
```

### Check access to the project

```bash
export GCP_PROJECT=example
gcloud config set project $GCP_PROJECT
```

```bash
gcloud config get-value project
```

## Step 1: Setup project and mandatory parameters

| Name | Description | Example | 
|------|-------------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the Autonomous Database belongs. | `example` |
| <a name="input_location"></a> [location](#input\_location) | GCP region where Autonmous Database is hosted. | `europe-west2` |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC network used by the Autonomous Database | `example-vpc` |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The subnet CIDR range for the Autonmous Database | `10.1.0.0/24` |
| <a name="input_customer_email"></a> [customer\_email](#input\_customer\_email) | The email address used by Oracle to send notifications regarding databases and infrastructure. | `your_email@example.com` |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password for the default ADMIN user | "Your0wnV@lue" |

## Step 2: Provision with Terraform

### Initialize Terraform 
```bash
terraform init
```

### Review plan and provision
```bash
terraform plan
```

```bash
terraform apply
```

## Step 3: Clean up

```bash
terraform destroy
```
# Oracle Database@Google Cloud

## Provision Autonomous Database with Terraform
<walkthrough-tutorial-duration duration="20"></walkthrough-tutorial-duration>

![gcp-oci-adbs-quickstart](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp/blob/adbs-ai/images/gcp-oci-adbs-quickstart.png?raw=true)

In this tutorial, you will 

1. Setup your Terraform environment for this tutorial
2. Provision an Oracle Autonomous Database in a new VPC
3. Provision an client VM in a new client subnet
4. Perform a sample query from client VM
5. Cleanup the environment

**Let's get started!**

<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Prerequisites
This tutorial has the following prerequisites:
- **[Oracle Database@Google Cloud subscription](https://console.cloud.google.com/marketplace/product/oracle/oracle-database-at-google-cloud)**
- **[Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)**
- **[Google Cloud CLI](https://cloud.google.com/sdk/docs/install)** 
- **[Terraform 1.5+](https://cloud.google.com/docs/terraform/install-configure-terraform#cloud-shell)** 

<walkthrough-footnote></walkthrough-footnote>

### Verify software installation
- **Google Cloud CLI** You should have result like `Google Cloud SDK XXX.X.X`
  ``` sh
  gcloud -v | grep SDK
  ```
- **Terraform**: You should have result like `Terraform vX.X.X`
  ``` sh
  terraform -v | grep "Terraform v"
  ```
<walkthrough-footnote></walkthrough-footnote>


### Cloud Shell in Default Mode (recommended) <walkthrough-cloud-shell-icon	></walkthrough-cloud-shell-icon>
- **Cloud Shell** already [pre-installed tools](https://cloud.google.com/shell/docs/how-cloud-shell-works#tools) e.g. Terraform and Google Cloud CLI. 
- **Trust the repo** when you open this tutorial in Cloud Shell, the session will be in Default Mode that come with integrated authorization and persistent storage.
- If you didn't trusted the repo, the session will be in [**Ephemeral Mode**](https://cloud.google.com/shell/docs/using-cloud-shell#choosing_ephemeral_mode) that **all the files you create in this session will be lost** on session end, including your terraform stage and customized configuration. The integrated authorization is not supported as well.



<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Authenication Google CLI & Terraform
### Cloud Shell <walkthrough-cloud-shell-icon	></walkthrough-cloud-shell-icon>
- When you firstly use `gcloud` or `terraform`, it prompts you to authorize like below:
  ![Authorize Cloud Shell](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp/blob/adbs-ai/images/gcp-authorize-cloud-shell.png?raw=true)
- Simply click `Authorize` when you see it (in the next step) to allow the tool using your credentials to make calls.
- **You can proceed to next step if you're using Cloud Shell.** 

<walkthrough-footnote></walkthrough-footnote>

### Local Shell / Cloud Shell in Ephemeral Mode
Use the following commands for authorizing CLI and Terraform, or follow the links for more details.
- [**Authorizing Google Cloud CLI**](https://cloud.google.com/sdk/docs/authorizing#auth-google): 
  ```sh
  gcloud auth login
  ```
- [**Authorizing Terraform**](https://cloud.google.com/docs/terraform/authentication#local_dev_environment) 
  ```sh
  gcloud auth application-default login
  ```

<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>


## Google Cloud Project
- You need a Google Cloud Project to start provisioning resources for this tutorial. Follow this [document](https://cloud.google.com/resource-manager/docs/creating-managing-projects) to create one if you don't have one.
- You can find your current Project ID at the [Google Cloud Console](https://console.cloud.google.com/welcome)
- Check your project ID is active and accessiable using the following command. Replace the `PROJECT_ID` with your Project ID. 
  ``` sh
  gcloud projects describe PROJECT_ID
  ``` 
<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Provision an Autonomous Database + VPC
You will provision the resources by using [gcp-oci-adbs-quickstart](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp/tree/main/templates/gcp-oci-adbs-quickstart) template.


### 1. Customise configuration
- Update `project` and `customer_email` in <walkthrough-editor-select-line filePath="cloudshell_open/terraform-oci-multicloud-gcp/examples/adbs-minimal/main.tf" startLine="5" endLine="7" startCharacterOffset="0" endCharacterOffset="0">main.tf</walkthrough-editor-select-line>.
- Review and customise other parameters as needed.
- You can setup the admin password using environment variable as shown below. Or you will be prompted when applying the Terraform.
  ``` bash
  export TF_VAR_admin_password=YourOwnPw
  ``` 

### 2. Initialize Terraform 
Run the following command to initialize Terraform. This will prepare the working directory of Terraform configuration, including accessing state, downloading and installing provider plugins, and downloading modules.
``` bash
terraform init
``` 
### 3. Validate configuration
Run the following command to validate the configuration. This will generate an execution plan for you to preview the changes.
``` bash
terraform plan
``` 
### 4. Provision resources 
Run the following command to provision the resources when the plan is good to go. You will have to review and confirm the plan by typing `yes` before proceed. 
``` bash
terraform apply
``` 
<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Provision an client VM in a new client subnet
<walkthrough-editor-open-file filePath="cloudshell_open/terraform-oci-multicloud-gcp/examples/adbs-minimal/main.tf" startLine="2" endLine="3">Update project ID</walkthrough-editor-open-file>

```
module "oradb-client" {
  # source = "github.com/oracle-quickstart/terraform-oci-multicloud-gcp//templates/oradb-client"
  source = "../../templates/oradb-client"
  project = local.project
  location = local.location
  network_name = module.gcp-oci-adbs-quickstart.network_name
  cidr = "10.2.0.0/24"
}
```

```bash
terraform apply
```


<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Perform a sample query from client VM

### Connect to the VM
```bash
gcloud compute ssh --project "your_project_here" --zone "your_region" "your_vm_name"
```

### Connect to Autonomous Database
```bash
sqlplus admin@"your_connect_string"
```

### Query

```sql
select cloud_identity from v$pdbs;
```

<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Congratulations
You've successfully provision an Autonomous Database of *Oracle Database@Google Cloud with Terraform*. 
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

### What's next:

- **Continue with [RAG Chatbot engine](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp/blob/adbs-ai/docs/tutorials/adbs-rag-chatbot/README_RAG.md)**: Use the Autonomous Database you've just provisioned as vector database for building a RAG Chatbot engine.
- **Don't forget to clean up**: Run the following command to cleanup the environment when you're done with all the related tutorials.
    ```bash
    terraform destroy
    ```
- **Explore more**: See the [OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp) for more Terraform modules, templates, examples, and tutorials for Oracle Database @ Google.

<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>
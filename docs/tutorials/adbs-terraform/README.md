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

## Prerequisite
This tutorial has the following prerequisites:

- **[Terraform 1.5+](https://cloud.google.com/sdk/docs/install)** : Verify with `terraform -v` 
- **[Google Cloud CLI](https://developer.hashicorp.com/terraform/install)** : Verify with `gcloud -v`
- **[Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)** : For resources of this tutorial.

<walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> You should be all set if you're running this tutorial with Google Cloud Shell. A `Google Cloud project` is all you need for this tutorial. 

<walkthrough-footnote>[OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp)</walkthrough-footnote>

## Environment setup

<walkthrough-cloud-shell-icon></walkthrough-cloud-shell-icon> You should be all set if you're running this tutorial with Google Cloud Shell.

### Authenication

Application Default Credentials (ADC) is the recommended way to authenticate to Google Cloud when using Terraform.
https://cloud.google.com/docs/terraform/authentication

gcloud auth application-default login

```
gcloud projects describe PROJECT_ID
```

## Provision an Oracle Autonomous Database in a new VPC
### 
<walkthrough-editor-open-file filePath="cloudshell_open/terraform-oci-multicloud-gcp/examples/adbs-minimal/main.tf">Edit main.tf</walkthrough-editor-open-file>

<walkthrough-editor-select-line filePath="cloudshell_open/terraform-oci-multicloud-gcp/examples/adbs-minimal/main.tf" startLine="2" endLine="4" startCharacterOffset="0" endCharacterOffset="0">line 2-3</walkthrough-editor-select-line>

<walkthrough-editor-select-regex filePath="cloudshell_open/terraform-oci-multicloud-gcp/examples/adbs-minimal/main.tf" regex="\b(project|location)\b">LINK_TEXT</walkthrough-editor-select-regex>

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

## Congratulations
You've successfully provision an Autonomous Database of *Oracle Database@Google Cloud with Terraform*. 
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

### What's next:

- **Continue with RAG based Chatbot engine**: Start next tutorial to build an RAG based Chatbot engine base on the Autonomous Database you've just provisioned.
    ```bash
    cloudshell launch-tutorial -d test.md 
    ```
- **Don't forget to clean up**: Run the following command to cleanup the environment when you're done with all the related tutorials.
    ```bash
    terraform destroy
    ```
- **Explore more**: See the [OCI Multicloud Landing Zone for Google Cloud](https://github.com/oracle-quickstart/terraform-oci-multicloud-gcp) for more Terraform modules, templates, examples, and tutorials for Oracle Database @ Google.

# OCI Identity Domains Module Usage Example - OCI-GCP Identity Federation with SAML JIT
## Introduction

This example shows how to federate existing OCI default Identity Domain with GCP via SAML JIT

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice. 

2. Within *\<project-name\>*.auto.tfvars, provide tenancy connectivity information

3. In this folder, run the typical Terraaform/OpenTofu workflow:
```
tofu init
tofu plan -out plan.out
tofu apply plan.out
```
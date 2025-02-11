# Deploying Oracle Database on Google Cloud Platform (GCP)

One of the key benefits of using GCP is its ability to support a wide range of databases, including Oracle. In this blog post, we'll focus on deploying an Autonomous Database on Google Cloud Platform (GCP). An Autonomous Database is a self-managing database that automatically handles maintenance tasks, freeing up your time to focus on higher-level tasks.

 We will cover the following topics:

- Creating a virtual private cloud (VPC) network
- Creating subnets and firewall rules
- Creating a Ubuntu VM with access to Oracle Autonomous Database or a Windows VM for easy APEX development
- Deploying an Oracle Autonomous Database
- Configuring instaclient and sqlcl for Oracle Autonomous Database
- Loading vectors to our Oracle Autonomous Database vector store
- Performing similarity search and surfacing answers in the frontend

## Prerequisites

Before we begin, make sure you have the following prerequisites:

- A GCP account with the necessary permissions to create resources
- A Bash shell installed on your system
- The gcloud command-line tool installed and configured on your system
- Oracle Autonomous Database at Google Cloud Platform(GCP) marketplace image

## How to content

Content of this lab is split into 3 sections:

1. [Subscribe and deploy Oracle Database 23ai on Google Cloud](README_INFRASTRUCTURE.md)  
2. [AI Chatbot engine with Oracle Database 23ai on Google Cloud](README_AICHATBOT.md)  
3. [Add Streamlit Frontend App for Oracle Database 23ai on Google Cloud](README_FRONTEND.md)
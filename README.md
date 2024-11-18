# EKS Cluster Setup Project on AWS

## Project Overview
This project demonstrates the setup of an **Amazon EKS Cluster** in **AWS** with a secure architecture that involves the use of a **VPC**, **NAT Gateway**, **Load Balancer**, and **public/private subnets**. The goal of the project is to deploy services inside **Kubernetes** with controlled and secure internet access.

## Architecture Overview

The project includes the following components:

- **VPC** (Virtual Private Cloud) – The network in AWS where all resources are hosted.
- **Public and Private Subnets** – The **EKS** nodes are deployed in private subnets, and internet traffic is routed through the **NAT Gateway**.
- **NAT Gateway** – Allows private subnet nodes to access the internet without being directly exposed.
- **Load Balancer (NLB)** – Exposed to the internet, it routes traffic to the private subnets where the EKS nodes reside.
- **Route Tables** – Defining routes between the private and public subnets.
- **IAM Policies** – Defines access control for users and services in AWS.

## Architecture Components

### VPC
The VPC is created with a custom **CIDR Block** and all components (subnets, gateways, and routes) are defined dynamically based on project requirements.

### Subnets
- **Public Subnets**: The **Load Balancer** is deployed in public subnets, making it publicly accessible. The load balancer forwards requests to the EKS nodes located in private subnets.
- **Private Subnets**: The EKS nodes are deployed in private subnets, ensuring that they are not directly exposed to the internet. These private subnets access the internet via the **NAT Gateway**.

### NAT Gateway
The **NAT Gateway** is placed in the public subnet, allowing nodes in private subnets to access the internet for tasks like downloading updates or connecting to other AWS services, without exposing the nodes directly to internet traffic.

### EKS Cluster
The EKS cluster is deployed within the private subnets, keeping the nodes and services secure. The cluster is configured with **CoreDNS** and **EBS CSI Driver** to enable essential functionality for Kubernetes workloads.

### Load Balancer
The **Network Load Balancer (NLB)** is deployed in the public subnets and listens for HTTP (port 80) and HTTPS (port 443) traffic. It forwards the traffic to the services running in the private subnets of the EKS cluster.

### IAM Roles & Policies
The project uses **IAM roles** and **policies** to provide secure access to resources like S3 buckets and EKS nodes.

## Terraform Components

Terraform is used to automate the infrastructure setup, including the following resources:

- **VPC, Subnets, and Gateways**: These resources are defined in Terraform to create a private/public network structure.
- **IAM Roles & Policies**: Used to securely manage user access and resource permissions.
- **EKS Cluster**: The cluster is created using the **terraform-aws-modules/eks/aws** module.
- **Load Balancer**: Created and connected to EKS services.
- **Route Tables**: Defined for proper routing between the subnets.

## Step-by-Step - How the Project Works

### 1. VPC and Subnets Creation
- A **VPC** is created with a custom **CIDR Block**.
- **Public and Private Subnets** are set up within the VPC.
- Public subnets are connected to an **Internet Gateway**, while private subnets are connected to a **NAT Gateway**.

### 2. NAT Gateway Setup
- The **NAT Gateway** is placed in the public subnet to enable private subnet nodes to access the internet.

### 3. EKS Cluster Creation
- The **EKS Cluster** is created in the private subnets, so that the nodes are not directly exposed to the internet.
- The cluster is set up with essential add-ons such as **CoreDNS** and **EBS CSI Driver**.
- **IAM Policies** are created to control who can access the cluster .

### 4. Load Balancer Setup
- A **Network Load Balancer (NLB)** is created in the public subnets, making it accessible from the internet. It forwards incoming requests to the EKS nodes in the private subnets.

### 5. Route Tables Configuration
- **Route Tables** are defined to ensure that the NAT Gateway can route traffic between the private subnets and the internet.
- Traffic from the private subnets to the internet is routed through the NAT Gateway.

### 6. S3 Access Configuration
- **IAM roles** are defined to provide the necessary permissions for the cluster to interact with AWS services like **S3**.

## How to Run the Project

1. **Install Terraform** on your local machine.
2. **Define the Variables** in the `terraform.tfvars` file with your VPC, NAT Gateway, and cluster information.
3. **Run Terraform**:
   ```bash
   terraform init
   terraform apply

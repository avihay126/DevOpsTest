# EKS Cluster Setup with Terraform

This repository contains Terraform configurations to set up an Amazon EKS (Elastic Kubernetes Service) cluster along with necessary VPC and subnet configurations.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Variables](#variables)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Prerequisites
- AWS Account
- Terraform installed (version 1.4.5)
- AWS CLI installed and configured with access to your AWS account

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/DevOpsTest.git

2. Change directory into the project folder:
        cd DevOpsTest

3. Initialize Terraform:
        terraform init

4. Create an execution plan:
        terraform plan

5. Apply the configuration to create the resources:
        terraform apply

## Usage
After the EKS cluster and associated resources are set up, you can interact with the cluster using kubectl.

1. Update your kubeconfig file:
        aws eks --region eu-west-1 update-kubeconfig --name avihay-cluster

2. Check the cluster info:
        kubectl cluster-info

3. List all pods across namespaces:
        kubectl get pods --all-namespaces


## Variables

The following variables are defined in the Terraform configuration:

* **`region`**: The AWS region to deploy resources in (default: `eu-west-1`)
* **`vpc_id`**: The ID of the VPC where the resources will be deployed (default: `vpc-01b834daa2d67cdaa`)
* **`cidr_sub_a`**: CIDR block for the first subnet (default: `192.168.8.0/24`)
* **`cidr_sub_b`**: CIDR block for the second subnet (default: `192.168.9.0/24`)
* **`nat_gateway`**: The ID of the NAT Gateway (default: `nat-0440e3c0e49d26497`)
* **`cluster_name`**: Name of the EKS cluster (default: `avihay-cluster`)

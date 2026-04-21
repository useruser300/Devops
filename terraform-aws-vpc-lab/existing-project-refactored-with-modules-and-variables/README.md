# Terraform AWS Modular VPC Lab

A hands-on Terraform project that builds a simple AWS infrastructure using a **modular design**.

Instead of placing all resources in one file, the infrastructure is separated into two reusable modules:

- **network** → responsible for networking resources
- **compute** → responsible for the EC2 server layer

This structure follows a cleaner and more scalable Terraform design.

---

# Features

## Network Module

Creates:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Elastic IP
- NAT Gateway
- Public Route Table
- Private Route Table
- Route Table Associations

## Compute Module

Creates:

- Latest Amazon Linux 2 AMI (data source)
- Security Group
- EC2 Instance inside the private subnet

---

# Project Structure

```text
terraform/
├── provider.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
````

---

# Architecture Overview

The infrastructure includes:

* One VPC
* One Public Subnet
* One Private Subnet
* Internet Gateway attached to the VPC
* NAT Gateway inside the public subnet
* Elastic IP assigned to the NAT Gateway
* Public Route Table with internet access
* Private Route Table with NAT access
* EC2 instance deployed inside the private subnet

## Traffic Flow

```text
Public Subnet  -> Route Table -> Internet Gateway -> Internet
Private Subnet -> Route Table -> NAT Gateway -> Internet Gateway -> Internet
```

The EC2 instance does **not** receive a public IP.

---

# Module Communication

The `network` module exports values such as:

* `vpc_id`
* `public_subnet_id`
* `private_subnet_id`

The root module passes these outputs into the `compute` module.

```text
network module
   ↓ outputs
root module
   ↓ inputs
compute module
```

This demonstrates how Terraform modules interact using **outputs** and **variables**.

---

# Learning Goals

By completing this lab, you will understand:

* Terraform module structure
* Reusable infrastructure design
* Input variables and outputs
* Resource dependencies
* AWS VPC networking basics
* Public vs Private subnet design
* Safe infrastructure provisioning with Terraform

---

# Terraform Workflow

## Initialize Terraform

```bash
terraform init
```

## Preview the Execution Plan

```bash
terraform plan
```

## Apply the Infrastructure

```bash
terraform apply
```

## Destroy Resources After Testing

```bash
terraform destroy
```

---

# Variables Example

```hcl
aws_region          = "eu-central-1"
vpc_cidr            = "172.16.0.0/16"
public_subnet_cidr  = "172.16.2.0/24"
private_subnet_cidr = "172.16.1.0/24"
availability_zone   = "eu-central-1a"
instance_type       = "t2.micro"
```

---

# Important Notes

* Configure AWS credentials before running Terraform
* Do not place credentials inside Terraform files
* Always destroy resources after testing to avoid AWS costs
* This project is intended for learning and lab practice

---

# Summary

This project shows how to move from a single large Terraform file to a cleaner modular design by separating:

* **networking resources**
* **compute resources**

It is a practical example of writing structured, reusable, and maintainable Infrastructure as Code on AWS.



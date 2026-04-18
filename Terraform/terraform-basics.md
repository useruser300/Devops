# Infrastructure as Code (IaC)

Infrastructure as Code means that you use **code** instead of **manual configuration** to define cloud resources or data center resources.

Instead of opening:

- AWS
- Azure
- GCP

and creating resources one by one from the Console, you can write code that describes these resources, and then the tool executes this description and creates them for you.

This approach gives you more than one benefit:

- It automates the **provisioning** process of the infrastructure.
- It makes managing the infrastructure easier.
- It integrates with **Git** to manage different versions of the infrastructure.
- It allows you to go back to previous versions when needed.

The general idea looks like this:

- The developer writes the code.
- The code is managed with Git.
- Terraform sends this code to the **API** of the **Cloud Provider**.
- The resources are created in the cloud based on this code.

---

# Declarative vs Imperative

There are two main approaches in automation:

## Declarative

In this approach, you do not write the detailed steps one by one. Instead, you write the **desired final state**.

For example:

You say that you want:

- an EC2 Instance of type `t2.micro`

inside a specific infrastructure setup, and you leave the tool to reach this result.

This is the approach used by Terraform.

The advantage of this approach is that when you change something in the configuration, Terraform compares:

- the old configuration
- the new configuration

Then it applies only the required difference.

For example:

If you have an EC2 instance of type `t2.micro`, and then you change it to `t3.micro`, Terraform sees that the only difference is the instance type. So it handles this change instead of changing other things unnecessarily.

Advantages of the declarative approach:

- Changes are easier.
- Configuration files are shorter and clearer.
- You always know the current setup.
- You get a clear view of the state of your infrastructure.

## Imperative

In this approach, you write **step by step** what should happen.

For example:

- Do the first step.
- Then the second step.
- Then the third step.

Until you reach the required result.

This approach is closer to writing general programs or execution scripts.

---

# Mutable vs Immutable Infrastructure

## Mutable Infrastructure

Mutable infrastructure means that you already have existing infrastructure, and you can modify it while it is running.

Example:

You have a running server, and you want to install Nginx on it or update its configuration. So you use a tool like Ansible to modify this existing server.

Examples of tools that work with this approach:

- Puppet
- Chef
- Ansible

The idea of mutable infrastructure is that changes happen on the same existing thing.

## Immutable Infrastructure

Immutable infrastructure means that after a resource is deployed, you do not modify it directly. Instead, when you need an important change, you replace it with a new version.

Example:

You created an EC2 Instance of type `t2.micro`, and then you wanted it to become `t3.micro`.

Instead of modifying it in the same mutable way, the old resource is deleted and a new resource is created with the new specifications.

Common tools or environments related to this concept:

- Docker
- Kubernetes
- Terraform

---

# Agent-based vs Agentless Tools

## Agent-based Tools

In this approach, an **Agent** is installed on the devices or servers that you want to manage.

This Agent communicates with a **Master Node** or a central system that stores the configurations and controls the management of these devices.

So the basic idea is:

- There is an Agent installed on every managed device.
- The Agent communicates with the central system using an encrypted method.
- The configurations are stored centrally.

A well-known example of this approach:

- Puppet

## Agentless Tools

In this approach, you do not need to install an Agent on the devices.

Communication happens directly through protocols such as:

- SSH in the case of Ansible
- HTTPS in the case of Terraform when it communicates with the API of the Cloud Provider

Examples:

- Ansible
- Terraform

This makes deployment easier because you do not need to install Agents on every server.

---

# Benefits of IaC

Using Infrastructure as Code gives clear practical benefits:

## Efficiency

Automating deployment processes saves time and reduces manual effort.

## Easy Tracking and Versioning

You can keep several versions of the infrastructure and go back to any previous version when needed.

## Prevents Configuration Errors

Instead of a person configuring everything manually from the Console, the same configuration is executed automatically from code. This reduces human errors.

## Scalable Environments

If you have a file that creates 3 servers, you can easily change the value so it creates 100 servers using the same pattern.

## Simplified Disaster Recovery

If the infrastructure is lost or a major problem happens, the code still exists, and you can rebuild everything again from it.

---

# Common Tools in IaC

Important tools in this field include:

- Terraform
- Ansible
- AWS CloudFormation

Terraform is a general tool that works with more than one Cloud Provider.

CloudFormation is a native tool specific to AWS.

Ansible can also handle provisioning, but its most common use is configuration management.

---

# What is Terraform?

Terraform is an **Infrastructure as Code** tool that automates infrastructure across:

- Cloud environments
- On-prem environments

It uses readable code written in:

**HCL = HashiCorp Configuration Language**

Main characteristics of Terraform:

- Open-source
- Cloud-agnostic
- Declarative
- Focuses on the end state

Being cloud-agnostic means that you can use it with more than one Cloud Provider, such as:

- AWS
- Azure
- GCP

Terraform files usually have the extension:

- `.tf`

Examples:

- `main.tf`
- `provider.tf`

---

# Terraform Workflow

Working with Terraform goes through main stages:

## 1. Write

You write the code that defines the resources you want to create or modify.

## 2. Plan

You preview the changes before applying them, so you can see what will happen and whether there is an error.

## 3. Apply

You approve the changes, and then they are actually applied to the Cloud Provider.

In more detail, the workflow becomes:

1. Identify the required resources.
2. Write Terraform configurations.
3. Initialize Terraform using `terraform init`.
4. Plan using `terraform plan`.
5. Apply using `terraform apply`.
6. Destroy using `terraform destroy`.

---

# Deploying Infrastructure with Terraform

When building infrastructure on AWS, for example, you first need to understand the structure of the infrastructure itself and the relationship between its parts.

For example, you may want to create:

- VPC
- Public Subnet
- Private Subnet
- EC2 Instance inside the Private Subnet
- NAT Gateway inside the Public Subnet
- Internet Gateway
- Route Tables

For a design like this, it is not enough to know how to write the code only. You also need to understand:

- The relationship between the Route Table and the Subnet.
- That the Default Route in the Private Subnet goes to the NAT Gateway.
- That the Default Route in the Public Subnet goes to the Internet Gateway.
- That the EC2 instance in this example is inside the Private Subnet.

After you understand the architecture, you translate it into Terraform code inside `.tf` files.

---

# Terraform Commands

## Terraform Initialize

After writing the files, you start with the command:

~~~bash
terraform init
~~~

This command downloads the plugins or providers that Terraform needs so it can communicate with the Cloud Provider.

If you are working with AWS, it downloads the AWS plugin so Terraform can communicate with the AWS API.

## Terraform Plan

After that, you use:

~~~bash
terraform plan
~~~

This command does not apply anything. It only shows you the expected changes.

For example, it may tell you that it will create:

- VPC
- Subnets
- EC2
- Other resources

If the infrastructure already exists and you only added a new EC2 instance, Terraform will see that the only difference is adding this new EC2 instance.

So `terraform plan` shows the difference between:

- What currently exists
- What is written in the configuration files

## Terraform Apply

After checking the plan, you use:

~~~bash
terraform apply
~~~

Here, the changes are actually applied to the Cloud Provider.

## Terraform Destroy

If you want to remove the infrastructure that you created using Terraform, you use:

~~~bash
terraform destroy
~~~

Terraform then deletes the resources that it created.

---

# Infrastructure Provisioning vs Configuration Management

## Infrastructure Provisioning

Infrastructure provisioning means creating the base infrastructure from the beginning, such as:

- Servers
- Networks
- VPC
- Subnets
- Databases

Examples of tools used for this purpose:

- Terraform
- CloudFormation

This type focuses on creating the base infrastructure.

## Configuration Management

Configuration management means that after creating the infrastructure, you start configuring what is inside it.

For example:

- Installing Apache
- Installing Nginx
- Installing an application
- Modifying server settings

The common tool here is:

- Ansible

So the difference in short is:

- Provisioning = building the infrastructure itself
- Configuration Management = configuring what is inside the resources after they are created

However, Ansible can also do provisioning, but its most common use is configuration management.

---

# Terraform State

Terraform needs to know the current state of the infrastructure so it can compare it with what is written in the configuration files.

For this, it uses a file called:

`terraform.tfstate`

This file:

- Stores the current state
- Is written in JSON format
- Helps Terraform compare:
  - Desired State
  - Actual State

The general picture is:

- `main.tf` represents what you want to reach.
- `terraform.tfstate` represents the known current state.

Example:

If you have the following in `main.tf`:

- VPC
- Public Subnet
- Private Subnet

Then you add a second Private Subnet. Terraform compares this new desired setup with what exists in the State File. It discovers that the second Private Subnet does not exist, so it only adds that subnet.

---

# Local State vs Remote State

By default, the State File is saved locally on your machine.

This is fine if you work alone, but it becomes a problem in teamwork.

The problem is that other team members will not have the same state on their machines, which can cause conflicts or inconsistency.

The solution is to use Remote State.

In AWS, the State File can be stored inside:

**S3 Bucket**

This gives benefits such as:

- Team collaboration
- Consistent state
- Everyone accesses the same state
- Preventing conflicts between different versions of the state

The State File can also be encrypted inside S3.

---

# State Locking with DynamoDB

In teamwork, it is not enough to only store the State File in S3. We also need to prevent two people from modifying the state at the same time.

For this, Locking is used.

The idea is that when someone starts running `plan` or `apply`, a lock is created on the state so that another person cannot modify it at the same moment.

In this context, the service used is:

**DynamoDB**

It prevents simultaneous conflicts and keeps the state safe.

---

# Terraform Configuration Basics

When writing Terraform configuration, you usually have two basic files:

- `provider.tf`
- `main.tf`

## Required Providers

The first basic part is defining the required providers so Terraform knows which plugin it should download.

~~~hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
~~~

This part tells Terraform:

- We need the AWS Provider.
- The source is `hashicorp/aws`.
- Use a version compatible with `5.0`.

## Provider Configuration

After that, the provider itself is defined:

~~~hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "anaccesskey"   # your AWS login key
  secret_key = "asecretkey"    # your AWS secret key
}
~~~

This part defines the information that Terraform needs in order to communicate with AWS, such as:

- The Region
- Access Key
- Secret Key

But in practice, it is better not to put sensitive keys inside the file. Instead, use environment variables.

~~~bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-west-2"

terraform plan
~~~

This is better than saving the keys inside the code.

---

# Resource Definition

The first resource shown is an AWS EC2 Instance.

The code is:

~~~hcl
resource "aws_instance" "webserver" {
  ami           = "ami-051f7e7f6c2f40dc1"
  instance_type = "t2.micro"

  tags = {
    Name        = "webserver"
    Description = "Test webserver"
  }
}
~~~

Explanation of this block:

- `resource`  
  Means that you are defining a new resource.

- `"aws_instance"`  
  This is the resource type. Here it means an EC2 Instance.

- `"webserver"`  
  This is an internal name inside Terraform. You use it in the code to refer to this resource.

- `ami = "ami-051f7e7f6c2f40dc1"`  
  Defines the system image that will be used.

- `instance_type = "t2.micro"`  
  Defines the instance type in terms of CPU, memory, and capacity.

- `tags`  
  Adds tags to the resource.

- `Name = "webserver"`  
  This name appears in the AWS Console as the instance name.

- `Description = "Test webserver"`  
  A free description that explains the purpose of the instance.

So there is an important difference between:

- The internal name inside Terraform: `"webserver"`
- The name that appears in the AWS Console: `Name = "webserver"`

---

# Handling Dependencies in Terraform

Terraform does not work step by step like imperative scripts. Instead, it builds a Dependency Graph from the relationships between resources.

There are two types of dependencies:

## Implicit Dependencies

These are dependencies that Terraform discovers automatically when it sees that one resource depends on a value from another resource, such as:

- `.id`
- `.arn`
- `.bucket`

~~~hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
~~~

Here, Terraform automatically understands that:

- `aws_vpc.main` must be created first.
- Then `aws_internet_gateway.igw`.
- Then the Route that depends on the Gateway.

This is because there are direct references such as:

- `aws_vpc.main.id`
- `aws_internet_gateway.igw.id`

So you do not need to manually force the order in this case.

## Explicit Dependencies

Sometimes there is no direct reference that is enough for Terraform to know the execution order. In this case, you use `depends_on`.

~~~hcl
resource "aws_cloudwatch_log_group" "lambda_log" {
  name = "/aws/lambda/my-function"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my-function"
  filename      = "lambda.zip"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn

  depends_on = [aws_cloudwatch_log_group.lambda_log]
}
~~~

Here, you clearly say that:

`aws_lambda_function.my_lambda`

depends on:

`aws_cloudwatch_log_group.lambda_log`

So the CloudWatch Log Group must be created first, and then Lambda after it.

The idea of `depends_on` is that you force the order when it is not clear enough through normal references.

---

# General Workflow Overview

When you work with Terraform, the practical idea is:

1. Define the infrastructure you want.
2. Write it in `.tf` files.
3. Define the Provider and the Resources.
4. Run `terraform init`.
5. Run `terraform plan`.
6. Run `terraform apply`.
7. Terraform uses `terraform.tfstate` to know the current state.
8. In teamwork, use Remote State such as S3.
9. To prevent conflicts, use Locking such as DynamoDB.
10. Terraform understands resource order through Implicit and Explicit Dependencies.
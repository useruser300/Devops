# Terraform Lab Hands-on

This lab explains how to build **AWS infrastructure** using **Terraform** instead of doing everything manually through the AWS Console.

The main idea is to define the infrastructure inside Terraform files, and then Terraform creates the resources and connects them together in an organized and repeatable way.

---

# General Idea of the Lab

The main steps in this lab are:

1. Prepare the provider file
2. Write the resources inside `main.tf`
3. Run the basic Terraform commands:

~~~bash
terraform init
terraform plan
terraform apply
~~~

4. Verify the resources inside the AWS Console
5. Delete the resources after finishing by using:

~~~bash
terraform destroy
~~~

---

# Project Structure

The project structure looks like this:

~~~text
project-folder/
├── provider.tf
└── main.tf
~~~

There are two main files:

## provider.tf

This file contains the Terraform settings and the AWS provider configuration.

In this file, we define:

- the provider that will be used
- the provider version
- the required Terraform version
- the region where the resources will be created

Example:

~~~hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "eu-central-1"
}
~~~

The important points here are:

- `source = "hashicorp/aws"` means that Terraform will use the official AWS provider.
- `version = "~> 5.92"` means using a compatible version of the AWS provider without jumping to a different major version.
- `region = "eu-central-1"` means that the resources will be created in the Frankfurt Region.

---

# The main.tf File

The main.tf file contains the resources that will be created inside AWS.

In this lab, the main resources are:

- VPC
- Internet Gateway
- Public Subnet
- Private Subnet
- Elastic IP
- NAT Gateway
- Route Tables
- Route Table Associations
- Default Security Group
- EC2 instance inside the private subnet

---

# Preparing AWS Credentials

Before running Terraform, the AWS credentials must be ready.

They can be prepared in more than one way.

The best method in most cases is to use:

~~~bash
aws configure
~~~

After running the command, you enter:

- AWS Access Key ID
- AWS Secret Access Key
- Default region
- Output format

You can also use environment variables such as:

~~~bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
~~~

The important point is that Terraform must be able to access the AWS API using these permissions.

It is not recommended to put the access key and secret key directly inside Terraform files, because this is not secure, especially if the project will be uploaded to GitHub or shared with other people.

---

# Basic Terraform Commands

After preparing the files and the credentials, the basic Terraform commands are executed in order.

# terraform init

The first command is:

~~~bash
terraform init
~~~

This command initializes the Terraform project.

Its main purpose is to:

- download the AWS provider
- prepare Terraform working files
- create files such as `.terraform`
- make sure the project is ready for execution

This command does not create resources inside AWS. It only prepares the Terraform environment.

---

# terraform plan

After that, we run:

~~~bash
terraform plan
~~~

This command shows what Terraform plans to create, modify, or delete.

`terraform plan` does not actually apply the changes. It only gives a preview.

The goal is to review the plan before executing it.

Using it, we can know:

- how many resources will be created
- the names of the resources
- their properties
- whether something will be modified or deleted

---

# terraform apply

After reviewing the plan, the resources are created using:

~~~bash
terraform apply
~~~

After running the command, Terraform will ask for confirmation.

You write:

~~~text
yes
~~~

After that, Terraform starts creating the resources inside AWS.

---

# Resources Created in the Lab

The script builds a complete network inside AWS that contains a public subnet and a private subnet, with an Internet Gateway, a NAT Gateway, and an EC2 instance inside the private subnet.

---

# Fetching the Amazon Linux 2 AMI

At the beginning of `main.tf`, a data source is used to fetch the latest Amazon Linux 2 AMI:

~~~hcl
data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}
~~~

The goal of this part is to avoid writing the AMI ID manually.

The AMI is different from one region to another, so using `data "aws_ami"` is better than writing a fixed AMI ID that may not work in another region.

This code searches for the latest Amazon Linux 2 AMI owned by Amazon.

---

# Creating the VPC

The first main resource is the VPC:

~~~hcl
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}
~~~

The VPC is the private virtual network inside AWS.

You can think of it as the main network where the rest of the resources will be built.

In this lab, the following CIDR block is used:

~~~text
172.16.0.0/16
~~~

This means that the main network has a large range that can be divided into smaller subnets.

The tag:

~~~text
Name = "main-vpc"
~~~

is the name that appears in the AWS Console.

---

# Creating the Internet Gateway

After creating the VPC, the Internet Gateway is created:

~~~hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}
~~~

The Internet Gateway is the component that allows the VPC to connect to the internet.

For a subnet to become public, it must have a route to the Internet Gateway.

Here, the Internet Gateway is attached to the VPC using:

~~~hcl
vpc_id = aws_vpc.main.id
~~~

---

# Creating the Public Subnet

After that, the public subnet is created:

~~~hcl
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "public-subnet"
  }
}
~~~

This is a public subnet inside the VPC.

The most important settings here are:

~~~hcl
vpc_id = aws_vpc.main.id
~~~

This means that the subnet belongs to the VPC that we created.

~~~hcl
cidr_block = "172.16.2.0/24"
~~~

This is the range of the public subnet.

~~~hcl
map_public_ip_on_launch = true
~~~

This means that any EC2 instance created inside this subnet automatically gets a Public IP.

~~~hcl
availability_zone = "eu-central-1a"
~~~

This means that the subnet is located inside a specific Availability Zone.

---

# Creating the Private Subnet

After that, the private subnet is created:

~~~hcl
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "private-subnet"
  }
}
~~~

This is a private subnet inside the same VPC.

The private subnet does not automatically give Public IPs to the instances inside it.

Its CIDR is:

~~~text
172.16.1.0/24
~~~

Resources inside this subnet are not directly reachable from the internet.

---

# Difference Between Public Subnet and Private Subnet

A public subnet is a subnet that can connect to the internet, and the internet can reach the resources inside it if these resources have a Public IP and the security rules allow it.

A private subnet is a subnet where the resources cannot be reached directly from the internet.

However, resources inside a private subnet may still need to go out to the internet, for example to download updates or packages.

In this case, a NAT Gateway is used.

---

# Creating an Elastic IP for the NAT Gateway

Before creating the NAT Gateway, an Elastic IP must be created:

~~~hcl
resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-eip"
  }
}
~~~

The NAT Gateway needs a fixed Public IP.

This Public IP is created using an Elastic IP.

The setting:

~~~hcl
domain = "vpc"
~~~

means that the Elastic IP is dedicated for use inside a VPC.

And:

~~~hcl
depends_on = [aws_internet_gateway.igw]
~~~

means that Terraform must create the Internet Gateway first before creating this resource.

---

# Creating the NAT Gateway

After creating the Elastic IP, the NAT Gateway is created:

~~~hcl
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway"
  }
}
~~~

The NAT Gateway is placed inside the public subnet.

So:

~~~hcl
subnet_id = aws_subnet.public.id
~~~

means that the NAT Gateway is inside the public subnet.

And:

~~~hcl
allocation_id = aws_eip.nat.id
~~~

means that it uses the Elastic IP that was created earlier.

The NAT Gateway allows resources inside the private subnet to go out to the internet, but it does not allow the internet to directly reach them.

---

# Creating the Public Route Table

After that, a route table for the public subnet is created:

~~~hcl
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}
~~~

This route table belongs to the same VPC.

---

# Creating a Route from the Public Subnet to the Internet Gateway

A route is added inside the public route table:

~~~hcl
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
~~~

The meaning is:

~~~hcl
destination_cidr_block = "0.0.0.0/0"
~~~

Any traffic outside the local network goes to the internet.

~~~hcl
gateway_id = aws_internet_gateway.igw.id
~~~

means that this traffic will be routed to the Internet Gateway.

This is what makes the public subnet able to access the internet.

---

# Associating the Public Route Table with the Public Subnet

After creating the route table, it must be associated with the public subnet:

~~~hcl
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
~~~

This association is very important.

Without the association, the public subnet will not use the route table that we created.

---

# Creating the Private Route Table

After that, a route table for the private subnet is created:

~~~hcl
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}
~~~

This route table will be used to route outgoing traffic from the private subnet.

---

# Creating a Route from the Private Subnet to the NAT Gateway

A default route is added inside the private route table:

~~~hcl
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
~~~

The meaning is:

Any traffic outside the local network from the private subnet goes to the NAT Gateway.

This allows resources inside the private subnet to go out to the internet without being directly exposed to the internet.

---

# Associating the Private Route Table with the Private Subnet

After that, the private route table is associated with the private subnet:

~~~hcl
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
~~~

This association makes the private subnet use its own route table.

---

# Creating the Default Security Group

In this lab, the default security group is used:

~~~hcl
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "default-sg"
  }
}
~~~

The default security group is used here for simplicity.

In real environments, it is usually better to create a custom security group with clear rules based on the need, instead of relying on the default security group.

---

# Creating EC2 inside the Private Subnet

After that, an EC2 instance is created inside the private subnet:

~~~hcl
resource "aws_instance" "private_ec2" {
  ami                         = data.aws_ami.linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_default_security_group.default.id]
  associate_public_ip_address = false

  tags = {
    Name = "private-server"
  }
}
~~~

The important points here are:

~~~hcl
ami = data.aws_ami.linux.id
~~~

This means using the latest Amazon Linux 2 AMI that was fetched at the beginning of the file.

~~~hcl
instance_type = "t2.micro"
~~~

This means a small server type suitable for a lab.

~~~hcl
subnet_id = aws_subnet.private.id
~~~

This means that the server will be created inside the private subnet.

~~~hcl
associate_public_ip_address = false
~~~

This means that the server will not get a Public IP.

This makes the EC2 instance not directly reachable from the internet.

---

# The Idea of a Resource Block in Terraform

Any resource in Terraform has this structure:

~~~hcl
resource "RESOURCE_TYPE" "LOCAL_NAME" {
  ...
}
~~~

Example:

~~~hcl
resource "aws_vpc" "main" {
  ...
}
~~~

In this example:

- `aws_vpc` is the resource type.
- `main` is a local name inside Terraform only.

The local name is used to connect resources inside the code.

Example:

~~~hcl
aws_vpc.main.id
~~~

This means using the ID of the VPC whose local name is `main`.

The name that appears in the AWS Console usually comes from the tags:

~~~hcl
tags = {
  Name = "main-vpc"
}
~~~

---

# Connecting Resources Using References

Terraform connects resources together using references.

Examples:

- `aws_vpc.main.id`
- `aws_subnet.public.id`
- `aws_subnet.private.id`
- `aws_internet_gateway.igw.id`
- `aws_nat_gateway.nat.id`
- `aws_eip.nat.id`

This way allows Terraform to understand the relationships between resources.

Example:

~~~hcl
vpc_id = aws_vpc.main.id
~~~

This means that this resource belongs to the VPC that was created in the resource with the local name `main`.

Another example:

~~~hcl
subnet_id = aws_subnet.public.id
~~~

This means placing the resource inside the public subnet.

---

# Implicit Dependency and Explicit Dependency

Terraform usually understands the order of resource creation automatically through references.

Example:

~~~hcl
vpc_id = aws_vpc.main.id
~~~

This makes Terraform understand that the VPC must be created before the resource that depends on it.

This is called an implicit dependency.

But sometimes, we need to clearly define a dependency using:

~~~hcl
depends_on = [...]
~~~

This is called an explicit dependency.

---

# Validating the Configuration During Terraform Plan

When running:

~~~bash
terraform plan
~~~

Terraform may show validation errors or warnings.

This is normal while building infrastructure, especially during testing or when adjusting the configuration.

Examples of possible issues:

- a missing dependency between resources
- an incorrect reference
- a required argument is missing
- an invalid value for a resource setting
- an AMI that is not available in the selected region
- a networking configuration issue

The correct way to handle the issue is:

1. Read the error message carefully
2. Check the line number
3. Understand the real cause
4. Review the Terraform documentation
5. Update the code
6. Run `terraform plan` again

An error does not mean that the whole infrastructure is wrong. In many cases, only a small correction is needed.

---

# Applying Changes Using Terraform Apply

After this succeeds:

~~~bash
terraform plan
~~~

we run:

~~~bash
terraform apply
~~~

After confirming with:

~~~text
yes
~~~

Terraform creates the resources.

In this lab, several resources are expected to be created, such as:

- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Elastic IP
- Route Tables
- Routes
- Route Table Associations
- Security Group
- EC2 instance

---

# Verifying the Resources inside the AWS Console

After `terraform apply` succeeds, the resources should be verified inside the AWS Console.

You should make sure that:

- there is a VPC named `main-vpc`
- there is a public subnet
- there is a private subnet
- there is an Internet Gateway
- there is a NAT Gateway
- there is a route table for the public subnet
- there is a route table for the private subnet
- the public route table contains a route to the Internet Gateway
- the private route table contains a route to the NAT Gateway
- the EC2 instance exists inside the private subnet
- the EC2 instance does not have a Public IP

This step is important because it confirms that the infrastructure is not only written in Terraform, but was actually created correctly inside AWS.

---

# Terraform State File

Terraform creates an important file called:

~~~text
terraform.tfstate
~~~

This file contains the current state of the infrastructure managed by Terraform.

The state file contains information about the resources that were created, such as:

- the resource type
- its local name
- its IDs
- its current properties
- some values that were automatically generated by AWS

The file is usually in JSON format.

Terraform uses this file to compare:

- desired state: the required state written in the Terraform files
- current state: the state recorded in the state file
- actual infrastructure: the resources that actually exist in AWS

That is why the state file is very important.

---

# Importance of Remote State

If one person is working on the lab, the state file can stay local.

But if a team is working on the same infrastructure, it is not recommended to keep the state file only locally.

It is better to use a remote backend such as:

- S3 bucket
- with DynamoDB for state locking when needed

The idea is that everyone uses the same state file instead of each person having a different state.

---

# Mutable and Immutable Changes

Some changes in Terraform can be applied directly to the same resource.

Other changes cannot be applied directly, so Terraform deletes the resource and recreates it.

Sometimes when modifying a route or a specific resource, the plan may show:

- destroy
- create

This means Terraform will remove the resource and create it again.

This is normal behavior depending on the resource type and the property that was changed.

---

# Importance of Official Documentation

When using any resource such as:

- `aws_internet_gateway`
- `aws_nat_gateway`
- `aws_subnet`
- `aws_route`

you should check the Terraform documentation to make sure of:

- required arguments
- optional arguments
- usage examples
- possible values
- changes between versions

Example:

In `aws_nat_gateway`, the property:

~~~hcl
subnet_id
~~~

is required, because it defines in which subnet the NAT Gateway will be placed.

And in `aws_internet_gateway`, the property:

~~~hcl
vpc_id
~~~

defines the VPC that the Internet Gateway will be attached to.

---

# Deleting the Resources after Finishing the Lab

After finishing the lab, the resources should be deleted so the cost does not continue.

This is done using:

~~~bash
terraform destroy
~~~

Terraform will show the resources that will be deleted, then it will ask for confirmation.

You write:

~~~text
yes
~~~

After that, Terraform deletes the resources that it created.

This is one of the most important features of Infrastructure as Code, because you can create and delete the infrastructure using clear and repeatable commands.

---

# Practical Summary of the Script

The script builds the following infrastructure:

- AWS provider in the region: `eu-central-1`
- VPC: `172.16.0.0/16`
- Public subnet: `172.16.2.0/24`
- Private subnet: `172.16.1.0/24`
- Internet Gateway attached to the VPC
- NAT Gateway inside the public subnet
- Elastic IP assigned to the NAT Gateway
- Public route table with a default route to the Internet Gateway
- Private route table with a default route to the NAT Gateway
- EC2 instance inside the private subnet
- EC2 instance without a Public IP
- AMI fetched automatically using a data source
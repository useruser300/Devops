# What are Terraform Modules?

A Module in Terraform is simply:

A group of Terraform files where we place specific code that we want to reuse instead of writing it again every time from scratch.

This means that instead of writing inside the main `main.tf` file:

* VPC
* Subnet
* Route Table
* Security Group

every time from zero, you place this code inside a folder called for example:

`modules/vpc`

Then from the main file, you call this module and give it only the required values.

---

# Why Do We Use Modules?

The main reason:

* Organizing the code
* Reusability
* Reducing the size of `main.tf`
* Making work easier on large projects
* More than one person can use the same module by only changing the parameters

This means instead of having the main file full of resources, it becomes only:

* Use VPC module
* Pass `vpc_cidr`
* Pass `subnet_cidr`
* Pass `availability_zone`

and so on.

---

# Project Structure

~~~text
terraform/
├── modules/
│   └── vpc/
│       ├── main.tf
│       └── variables.tf
├── provider.tf
├── main.tf
├── variables.tf
└── terraform.tfvars
~~~

---

# File Inside modules/vpc/main.tf

~~~hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.az
}
~~~

This means:

* Create a VPC using `var.vpc_cidr`
* Create a Subnet inside the same VPC
* Use `public_subnet_cidr`
* Use `az`

---

# variables.tf Inside Module

Inside:

`modules/vpc/variables.tf`

~~~hcl
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "az" {
  type = string
}
~~~

---

# Main File main.tf in the Root Folder

~~~hcl
module "my_vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
}
~~~

---

# variables.tf in the Root Folder

~~~hcl
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "az" {
  type = string
}
~~~

---

# terraform.tfvars

~~~hcl
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
az                 = "us-east-1a"
~~~

---

# How Does the Whole Idea Work?

Very simply:

## Inside the Module

You write the real resource code:

* `aws_vpc`
* `aws_subnet`

## Inside the Main main.tf

You do not write resources again, you only say:

* Use this module
* Its source is `./modules/vpc`
* These are the values I want to pass to it

---

# Practical Benefit

Instead of writing every time:

~~~hcl
resource "aws_vpc" ...
resource "aws_subnet" ...
~~~

You can simply call the module:

~~~hcl
module "my_vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  az                 = "us-east-1a"
}
~~~

And if another person wants the same VPC with different values, they only change the values without touching the internal module code.

---

# Summary

The idea in short:

* Put reusable code inside `modules/vpc`
* Call it from the main `main.tf`
* Pass only variables to it
* Use the same module many times with different values
* Make the project cleaner and easier to manage

---

# Important Note

If you want to make the module stronger and more professional, you can also add `outputs.tf` inside the module so it returns for example:

* VPC ID
* Subnet ID

~~~hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}
~~~

Then in the main file you can use:

~~~hcl
module.my_vpc.vpc_id
~~~

---

# The Idea Very Simply

A module is like a Function in programming.

For example in Python:

~~~python
create_vpc("10.0.0.0/16")
~~~

You sent a value to the function, and the function received it and used it internally.

In Terraform it is the same thing.

---

# What Actually Happens?

When you write in the main `main.tf`:

~~~hcl
module "my_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}
~~~

Here you are telling Terraform:

* Go to this module
* There is a variable called `vpc_cidr`
* Give it this value: `10.0.0.0/16`

---

# What Happens Inside the Module?

Inside the module there is:

~~~hcl
variable "vpc_cidr" {
  type = string
}
~~~

This means:

Inside the module I am waiting for a value called `vpc_cidr`

Then later in the code:

~~~hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
~~~

Here Terraform says:

* `var.vpc_cidr`
* means the value that came to me from outside

So it replaces it with:

~~~hcl
cidr_block = "10.0.0.0/16"
~~~

---

# If There Is More Than One Resource Inside the Module, How Does It Work?

Imagine the module contains:

* VPC
* Subnet
* Internet Gateway
* Route Table
* Security Group
* EC2

Like this:

~~~hcl
resource "aws_vpc" "main" {}
resource "aws_subnet" "public" {}
resource "aws_internet_gateway" "igw" {}
resource "aws_route_table" "rt" {}
resource "aws_security_group" "web_sg" {}
resource "aws_instance" "web" {}
~~~

Terraform treats the module as if it were a normal Terraform file containing multiple resources.

This means when running:

~~~bash
terraform plan
terraform apply
~~~

Terraform enters the module, reads all files inside it, and builds the Dependency Graph.

---

# How Does Terraform Know the Creation Order?

Not because it is inside a module, but because the resources are connected to each other.

Example:

~~~hcl
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
}
~~~

Here Terraform understands:

Subnet cannot be created before VPC.

Another example:

~~~hcl
resource "aws_instance" "web" {
  subnet_id = aws_subnet.public.id
}
~~~

Terraform understands:

EC2 cannot be created before Subnet.

So inside the module, the same normal Terraform rules apply.

---

# How Do Values Move from Outside into the Module?

When you write in the main file:

~~~hcl
module "network" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  az       = "us-east-1a"
}
~~~

You are sending Inputs to the module.

Inside the module there is:

~~~hcl
variable "vpc_cidr" {}
variable "az" {}
~~~

Terraform creates mapping:

| Outside Module             | Inside Module  |
| -------------------------- | -------------- |
| `vpc_cidr = "10.0.0.0/16"` | `var.vpc_cidr` |
| `az = "us-east-1a"`        | `var.az`       |

So inside the module:

~~~hcl
cidr_block = var.vpc_cidr
~~~

Actually becomes:

~~~hcl
cidr_block = "10.0.0.0/16"
~~~

---

# If Multiple Resources Inside the Module Use the Same Value?

Completely normal.

Example:

~~~hcl
variable "project_name" {}
~~~

And it is used in many places:

~~~hcl
tags = {
  Name = var.project_name
}
~~~

In VPC, EC2, and SG.

You pass the value once:

~~~hcl
project_name = "prod-app"
~~~

And all resources use it.

---

# What If I Do Not Pass a Value?

There are 3 important cases:

## Case 1: Variable Has Default

~~~hcl
variable "instance_type" {
  default = "t3.micro"
}
~~~

Terraform will use the default value.

## Case 2: Variable Without Default

~~~hcl
variable "vpc_cidr" {}
~~~

Terraform will give an Error:

~~~text
Missing required argument
~~~

Because this input is required.

## Case 3: Value Is Not Used at All

If you have a variable inside the module but no resource uses it, nothing important happens, but it is bad design.

---

# Can the Same Module Be Used More Than Once?

Yes.

~~~hcl
module "dev" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "prod" {
  source   = "./modules/vpc"
  vpc_cidr = "172.16.0.0/16"
}
~~~

The same module, but with different values.
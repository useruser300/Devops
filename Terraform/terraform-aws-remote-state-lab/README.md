# Terraform Lab: Remote State with S3 Backend, DynamoDB Locking, and Versioning

# Introduction

This lab explains how to set up Terraform Remote State professionally on AWS using an S3 Backend with DynamoDB Locking and Versioning.

The main goal of this project is to move from storing the Terraform State file locally on the machine to storing it in a centralized and secure way inside Amazon S3.

This approach is widely used in real working environments because it improves collaboration between team members, protects the state file, and makes infrastructure management more organized.

In addition to remote storage, this lab also implements State Locking using DynamoDB. This mechanism prevents more than one person from modifying the same infrastructure at the same time, which helps avoid conflicts, state file corruption, or update issues.

S3 Versioning was also enabled. This is an important feature that keeps previous copies of the state file, so it is possible to return to earlier versions when needed in case of an accidental change or an unexpected problem.

---

# What Was Implemented?

In this lab, the following components were created and configured:

- S3 Bucket to store the Terraform State file remotely
- Enabled Versioning on the bucket to keep previous versions
- Created a DynamoDB Table for State Locking
- Configured an S3 Backend inside Terraform
- Enabled Encryption to protect the state file

As a result, the workflow became closer to real production environments instead of relying only on the local `terraform.tfstate` file.

---

# Project Files

The project was divided into three main files:

## provider.tf

This file contains the basic settings, such as:

- Required Terraform version
- Required AWS Provider version
- Provider source
- AWS region used, which is `eu-central-1`

Its purpose is to prepare Terraform to connect to Amazon Web Services.

## main.tf

This file contains the resources that will be created, which are:

- Create S3 Bucket
- Enable Versioning on the bucket
- Create DynamoDB Table for Locking

This file represents the main infrastructure of the project.

## backend.tf

This file is responsible for configuring the Remote Backend inside Terraform.

Through it, Terraform is instructed that:

- The state file will be stored inside S3
- DynamoDB will be used for Locking
- The state file will be encrypted
- The same selected region will be used

This means that this file is what moves Terraform from Local State to Remote State.

---

# Final Result

After completing this lab, Terraform no longer stores the state file locally. Instead, it is stored securely inside AWS, protected from conflicts through Locking, and previous versions can be restored through Versioning.

This is considered one of the best practical approaches in the world of Infrastructure as Code using Terraform and Amazon Web Services.

---

# Using the Terraform Extension Inside Visual Studio Code

It is useful to install a Terraform extension inside Visual Studio Code, such as the HashiCorp Terraform extension.

This extension helps with:

- Syntax Highlighting so the code appears clearer and easier to read
- Auto Completion while writing the configuration
- Easier manual writing of Terraform files
- Making `.tf` files easier and more organized to work with

For that reason, it is recommended to install the extension before starting to write Terraform files.

---

# Returning to the Official Documentation

After deleting the old configuration, the official HashiCorp Terraform documentation was reviewed to search for the resource related to Amazon Web Services S3 Bucket.

If you search for:

~~~text
aws_s3_bucket
~~~

You will find the resource used to create an S3 Bucket together with the official example.

The same result can also be reached directly through Google by searching:

~~~text
aws s3 bucket terraform
~~~

Usually, the first result will be the official HashiCorp page.

---

# Creating an S3 Bucket

The basic example was taken from the documentation, then modified.

Simple example:

~~~hcl
resource "aws_s3_bucket" "s3" {
  bucket = "my-terraform-state-bucket11223344"
}
~~~

---

# Important Notes

In the documentation, you will find that some properties are:

- Optional
- Mandatory

In the case of S3 Bucket, Terraform can sometimes assign a random and unique name automatically, but here the name was chosen manually.

When creating an Amazon Web Services S3 Bucket through Terraform, the two most important points are:

- The bucket name must follow naming rules (lowercase and without underscore)
- The bucket name must be globally unique across all AWS

---

# Running terraform plan then terraform apply

~~~bash
terraform plan
terraform apply
~~~

---

# Verifying the S3 Bucket Creation from AWS Console

After successful execution, AWS Console was opened and the S3 service was checked to confirm that the bucket had actually been created.

The new bucket appeared successfully, but it was empty at first because no files had been uploaded to it yet.

---

# Next Step: Using S3 as Backend for Terraform State

After creating the S3 Bucket, the next step was:

Making Terraform store the state file inside S3 instead of local storage.

For that purpose, the Terraform Backend documentation was reviewed by searching for:

~~~text
Terraform S3 backend
~~~

On the official page, you will find an example showing how to configure an S3 backend.

It can also be found through Google or even by asking ChatGPT, but the best reference remains the official documentation.

---

# Important Notes About the S3 Backend

The documentation explains that:

- Using Amazon DynamoDB for State Locking is strongly recommended
- But it is not mandatory
- It is also recommended to enable Versioning on the bucket

At first, only the basic configuration was tested, which means storing the state inside S3 without DynamoDB.

---

# Creating backend.tf

A new file was created called:

~~~text
backend.tf
~~~

The backend settings were placed inside it.

Example:

~~~hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket11223344"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
~~~

---

# Explanation of the Values

- `bucket`  
  The name of the S3 Bucket that was created

- `key`  
  The path inside the bucket where the state file will be stored  
  Here it was placed directly in the root with the name:

~~~text
terraform.tfstate
~~~

- `region`  
  The region where the bucket exists  
  Here it was:

~~~text
eu-central-1
~~~

---

# Running terraform init After Adding the Backend

After saving `backend.tf`, the following command was executed:

~~~bash
terraform init
~~~

Terraform noticed that there was a new backend.

Then a question appeared similar to:

~~~text
Do you want to copy existing state to the new backend?
~~~

The answer was:

~~~text
yes
~~~

Terraform then moved the state file from local storage to the S3 Bucket.

---

# Verifying Upload of the State File to S3

After that, AWS Console was opened again, then the S3 Bucket was checked.

After refresh, the file:

~~~text
terraform.tfstate
~~~

appeared inside the bucket.

From that moment, any new change in Terraform would affect the state file stored in S3, not the local file.

---

# Returning from Remote Backend to Local Backend

If later you want to return from S3 Backend to Local Backend, it can be done this way:

1. Delete the file:

~~~text
backend.tf
~~~

2. Run:

~~~bash
terraform init -migrate-state
~~~

Terraform will move the state from the old backend to the new backend, which is now Local.

---

# Deleting the S3 Bucket After Returning to Local State

After returning to local state, the following can be executed:

~~~bash
terraform destroy
~~~

This will delete the created resources, including the S3 Bucket.

After deleting the S3-related configuration, the project will return as if it started from the beginning, and only the basic provider settings will remain.

For example:

- `main.tf` becomes empty
- The state file returns to local mode
- No additional resources remain

---

# Using S3 with DynamoDB and Versioning

After testing the basic backend, a better configuration was requested that includes:

- S3 Bucket
- Versioning Enabled
- DynamoDB Table for state locking

Then a suitable configuration was obtained, and the important parts were taken from it.

---

# Creating S3 Bucket and DynamoDB Table

At first, there was code that also contained the provider block, but this part was removed because the provider already exists in the project.

Only the required resources were kept.

Example:

~~~hcl
resource "aws_s3_bucket" "tf_state" {
  bucket        = "my-terraform-state-bucket11223344"
  force_destroy = true
}
~~~

---

# Note About force_destroy

The option:

~~~hcl
force_destroy = true
~~~

means that when running destroy, the bucket will be deleted even if it contains files.

This is useful for testing or in non-production environments, but it is not an ideal option in production because you may delete the bucket and its contents by mistake.

---

# Enabling Versioning on the S3 Bucket

Then versioning was added:

~~~hcl
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
~~~

This guarantees that the state files inside the bucket will have different versions, and previous versions can be restored when needed.

---

# Creating a DynamoDB Table for Locking the State

Then a DynamoDB table was created in the following way:

~~~hcl
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
~~~

---

# Explanation of the Settings

- `name`  
  The table name that will appear in AWS Console

- `billing_mode = "PAY_PER_REQUEST"`  
  Billing will be based on usage

- `hash_key = "LockID"`  
  This is the primary key of the table

- `attribute`  
  `LockID` was defined with the type:

  - `S = String`

---

# Running terraform plan then terraform apply

After writing the configuration for:

- S3 Bucket
- S3 Versioning
- DynamoDB Table

The following commands were executed:

~~~bash
terraform plan
terraform apply
~~~

In one attempt, an error appeared because the S3 Bucket name was already in use, so it was changed to another name that was more unique.

After changing the name, the following command was executed again:

~~~bash
terraform apply
~~~

Both resources were created successfully.

---

# Verifying Resource Creation from AWS Console

After successful execution, the following were checked:

## 1) DynamoDB Table

The table appeared inside DynamoDB, together with the partition key:

~~~text
LockID
~~~

## 2) S3 Bucket

The bucket appeared inside S3.

---

# Using These Resources in backend.tf

After that, the proper backend settings were placed inside the file:

~~~text
backend.tf
~~~

Example:

~~~hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket11223344"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
~~~

---

# Explanation of the Additional Settings

- `dynamodb_table`  
  The name of the DynamoDB table that will be used to lock the state

- `encrypt = true`  
  Encrypts the state file inside S3

---

# Important Note: terraform init Must Be Run First, Not terraform plan

After adding a new backend or modifying backend settings, you should not start with:

~~~bash
terraform plan
~~~

Instead, you must run:

~~~bash
terraform init
~~~

Because Terraform needs to reinitialize the backend first.

When running it, Terraform will detect that there is a new backend, then it will ask:

~~~text
Do you want to copy existing state to the new backend?
~~~

The answer should be:

~~~text
yes
~~~

Through this step, the state file is moved into the S3 Bucket.

---

# Final Verification of the State File Inside S3

After successful `terraform init`, AWS Console was opened again, then S3 was checked.

The state file appeared inside the bucket.

This means Terraform is now using a Remote Backend instead of a Local State File.

---

# Why Do We Use DynamoDB with Terraform State?

The reason is to prevent conflicts when more than one person works on the same infrastructure at the same time.

## The Problem

If two people try to modify the same state file at the same time, problems may happen such as:

- Write conflicts
- Corruption of the state
- Inconsistency between the real resources and what exists in the state file

## The Solution

When using DynamoDB Locking:

- If one person is working on the state file, a lock is created
- While this lock exists, another person cannot use the same state at the same time
- This prevents simultaneous changes that could cause problems
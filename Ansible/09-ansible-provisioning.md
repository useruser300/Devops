# Ansible Provisioning (Cloud) — AWS Collections, boto3, API Calls, and Localhost Execution (DevOps Notes)

## What is Ansible Provisioning in This Context?

Previously, the focus was:
- Infrastructure already exists (servers are running)
- Ansible is used for **Configuration Management**:
  - install packages
  - configure services
  - apply configuration changes

Here the focus changes:
- Infrastructure does **not exist yet**
- Ansible is used to **provision cloud resources** from scratch:
  - launch servers (EC2)
  - create networks (VPC)
  - manage IAM users, groups, and policies
  - manage other cloud services

Cloud providers:
- AWS
- GCP
- Azure

Important notes:
- Ansible *can* do provisioning
- Its strongest area is still **configuration management**
- Terraform is more commonly used for large-scale provisioning
- This section focuses on concepts and basic workflow

---

## Ansible Collections (Modern Packaging)

Ansible Collections are the modern way to distribute automation content.

Instead of everything being inside Ansible core, content is packaged into **collections** that you install when needed.

A collection may include:
- Modules
- Roles
- Plugins
- Examples

Concept:
- If you work with AWS, you install an AWS collection
- If you work with network vendors, you install their collections
- You reuse existing automation instead of writing everything manually

The idea is simple:  
If you want to work with AWS, Cisco, Fortinet, or even advanced Linux automation, you don’t build everything from scratch—you install the right Collection and use what’s inside it directly in your Playbook.

---

## Core Requirement 1: AWS Collection

To manage AWS with Ansible, you need an AWS-specific collection.

### What Is a Collection?
A collection is:
- A bundle of related Ansible content (modules, plugins)
- Usually provider- or vendor-specific (AWS, Cisco, etc.)

For AWS:
- Collection name: `amazon.aws`
- Contains modules for EC2, VPC, IAM, and more

### Install AWS Collection
```bash
ansible-galaxy collection install amazon.aws
```

This installs AWS-related modules required for provisioning.

---

## Core Requirement 2: boto3 (Why It Is Required)

### Why boto3 Is Needed

For normal configuration management:
- Ansible connects to servers via **SSH**

For cloud provisioning:
- Ansible does **not** use SSH
- It communicates with cloud providers via **API calls**

### boto3 Requirement
- `boto3` is the AWS Python SDK
- AWS Ansible modules rely on boto3 internally

Install boto3 on the control node:
```bash
pip install boto3
```

Key concept:
- Ansible → AWS modules → boto3 → AWS API
- Ansible communicates with AWS services through their APIs
- AWS modules rely on boto3 internally to perform these API calls

---

## Example AWS Modules

Inside the AWS collection, there are modules for common AWS resources.

Examples:
- **EC2 instance module**
  - Manages EC2 virtual machines
- **VPC module**
  - Manages Virtual Private Cloud networking
- **IAM group module**
  - Manages IAM groups

---

## IAM Group Module (Concept)

### What Is an IAM Group?
An IAM Group is used to:
- Group IAM users
- Attach permissions (policies) to the group
- Automatically grant permissions to all members

Example:
- Group name: `admins`
- Admin policy attached
- Any user added becomes an admin

This avoids managing permissions user-by-user.

### What the Module Does
The IAM group module can:
- create groups
- delete groups
- ensure groups exist (`present`)
- ensure groups do not exist (`absent`)

This enables **security-as-code** for AWS.

---

## Example Task: Launching an EC2 Instance (Concept)
Example (structure concept):

```yaml
- name: Launch an EC2 instance
  amazon.aws.ec2_instance:
    name: myserver
    instance_type: t2.micro
    image_id: ami-0123456789abcdef0
    region: us-east-1
    state: present
```

Meaning:
- You call an AWS module from the AWS collection
- You define the **desired state**:
  - `state: present` → ensure the resource exists
- You provide the **instance configuration**:
  - `instance_type`
  - `image_id`
  - `region`
  - `name`

---

## AWS Provisioning Workflow

### Step 1: Install AWS Collection
```bash
ansible-galaxy collection install amazon.aws
```

### Step 2: Ensure boto3 Is Installed
```bash
pip install boto3
```

### Step 3: Use AWS Modules in Playbooks
- Write playbooks using modules from the AWS collection
- Ansible makes API calls to AWS

---

## How Ansible Connects During Cloud Provisioning

### Configuration Management
- Control Node → Managed Node
- Connection method: SSH
- Tasks run on remote servers (managed nodes)

### Cloud Provisioning
- No SSH connection to “AWS” itself for provisioning resources
- Ansible talks directly to AWS APIs
- Requires:
  - AWS Collection
  - boto3

---

## Connecting Ansible to AWS (Credentials)

To allow Ansible (and your terminal) to access AWS:
- AWS credentials are required

Credentials include:
- Access Key ID
- Secret Access Key

Configure locally using AWS CLI:
```bash
aws configure
```

This sets:
- Access key
- Secret key
- Default region
- Output format

Important:
- Secret keys must never be shared or committed to Git

---

## Why `hosts: localhost` and `connection: local` Are Used

When provisioning AWS:
- Tasks run on the **control node**
- Modules call AWS APIs from the local machine

Typical playbook settings:
- `hosts: localhost`
- `connection: local`
- `gather_facts: no` (often unnecessary)

---

## Example: Provision an IAM Group (Concept)

```yaml
---
- name: Create IAM Group on AWS
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:
    - name: Create IAM group
      amazon.aws.iam_group:
        name: testgroup1
        state: present
```

Important points:
- No inventory file required
- No managed nodes involved
- All actions happen via AWS APIs

---

## Running AWS Provisioning Playbooks

Because execution is local:
```bash
ansible-playbook playbook.yml
```

Notes:
- No `-i hosts.ini` needed
- Inventory is irrelevant for cloud provisioning
- Playbook directly manages AWS resources

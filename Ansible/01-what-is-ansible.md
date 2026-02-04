# Ansible — Core Concepts (DevOps Notes)

## What is Ansible?

Ansible is an **open-source automation tool** used for:

- **Configuration Management**
- **Infrastructure Provisioning**

It helps automate repetitive system administration tasks across many servers instead of doing them manually server-by-server.

---

## Key Characteristics of Ansible

### 1) Open-source
Ansible is **open-source**, freely available, and widely adopted in DevOps and IT operations.

Its main automation goals include:
- Installing software packages
- Managing server configuration
- Provisioning infrastructure resources

---

### 2) Agentless (Major advantage)
Ansible is **agentless**, which means:

- No agent needs to be installed on managed servers
- Requirements are minimal:
  - **SSH access** to target servers
  - **Python installed on Linux targets** (usually already present)

Ansible connects over SSH, executes tasks remotely, and does not require persistent software on managed nodes.

---

### 3) Simple (YAML syntax)
Ansible uses **YAML**, which is:
- Easy to read
- Easy to write
- Clear and structured

Playbooks are readable even with minimal YAML experience.

---

### 4) Declarative (can be Imperative)

Ansible is primarily **declarative**, but also supports **imperative** execution.

#### Declarative approach (Desired State)
You define the final state:
- Apache installed and running
- Git installed
- Nginx present

Ansible ensures the system matches this state.

#### Imperative approach (Command-by-command)
You can execute explicit commands using:
- Ad-hoc commands
- shell / command modules

---

### 5) Idempotent Modules
Many Ansible modules are **idempotent**, meaning:

- Re-running a playbook is safe
- Changes are applied only if required

Example:
- If Apache is already installed → no action
- If Apache is missing → install it

---

## How Ansible Works (Architecture)

Ansible is built around three core components.

---

### 1) Control Node
The **Control Node** is where Ansible is installed and executed.

Responsibilities:
- Write playbooks
- Define inventories
- Run automation

The control node can be:
- A laptop
- A VM
- A server

---

### 2) SSH Connection
Ansible uses **SSH** for secure communication.

Common setup:
- SSH key-based authentication (recommended)
- Password authentication (possible, not preferred)

Key model:
- Public key → target servers
- Private key → control node

---

### 3) Managed Nodes
**Managed Nodes** are the systems Ansible configures.

Examples:
- Linux servers
- Cloud instances
- Multiple hosts at once

These nodes receive instructions from the control node.

---

## Example Use Case (Configuration Management)

Typical scenario:
- Server already exists
- Configuration changes are needed

Examples:
- Install Apache
- Install Nginx
- Install Git
- Apply configuration rules

This is classic **configuration management**.

---

## Manual vs Scripted vs Ansible Automation

When managing multiple servers and installing the same package (e.g., Nginx), there are three approaches.

---

### 1) Manual Approach

#### How it works
You SSH into each server and run OS-specific commands.

Examples:
- Ubuntu / Debian:
  ```bash
  sudo apt install nginx
  ```
- Alpine:
  ```bash
  sudo apk add nginx
  ```

#### Pros
- No setup required

#### Cons
- Slow and repetitive
- High human error risk
- No centralized change tracking

---

### 2) Scripted Automation

#### How it works
You write scripts that:
- Detect OS
- Execute correct commands

#### Pros
- Centralized logic

#### Cons
- Requires custom scripting
- Not idempotent by default
- Windows support adds complexity

---

### 3) Ansible Automation (Playbooks)

#### How it works
- Define hosts in inventory
- Write a playbook describing desired state
- Execute once from control node

#### Pros
- Idempotent
- Handles OS differences via modules
- Centralized automation
- Cleaner than shell scripts

#### Cons
- Requires initial setup

---

## Inventory File Concept

The **inventory file** defines managed systems.

It includes:
- IP addresses
- Hostnames
- Groups of servers

Ansible uses the inventory to target hosts automatically.

---

## Python Requirement Note

For Linux managed nodes:
- Python must be installed
- Ubuntu / Debian usually include it
- Alpine may require manual installation

Python is required for most Ansible modules.

---

## Main Uses of Ansible

Ansible is commonly used in three major areas.

---

### 1) Configuration Management
Automates:
- Software installation
- Server configuration
- Ongoing maintenance

Applies consistently across:
- On-prem servers
- Cloud infrastructure

---

### 2) Infrastructure Provisioning
Used to create infrastructure resources:

- Servers / instances
- Containers
- Cloud services:
  - EC2
  - S3
  - Lambda
  - VPC
  - ALB

Often integrates with cloud APIs.
Additional libraries may be required (e.g., **boto3** for AWS).

---

### 3) Network Automation
Used to automate:
- Routers
- Switches
- Firewalls

Examples:
- Interface configuration
- Routing setup
- Firewall rule management

This is why network engineers often learn:
- Python
- Ansible

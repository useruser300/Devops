# Passwordless SSH — Core Concepts (DevOps Notes)

## Passwordless SSH (Why it matters for Ansible)

In Ansible, the **Control Node** connects to **Managed Nodes** mainly using **SSH**.

Problem:
- If every connection requires entering a **username + password**, automation becomes slow and inefficient.
- Ansible must be able to connect and run tasks **without manual password prompts**.

Solution:
- Use **SSH key-based authentication** (Passwordless SSH).

This is a general SSH mechanism (not Ansible-specific), but it is critical for reliable and scalable Ansible automation.

---

## SSH Key Pair Concept (Public + Private)

An SSH key pair consists of two linked keys:

- **Private Key**
  - Stays on the Control Node
  - Must remain secret
  - Never shared

- **Public Key**
  - Copied to the target server
  - Stored in the server’s trusted keys list

Security principle:
- Anyone with the **private key** can access servers that trust its matching public key.
- Protect the private key at all times.

---

## Passwordless SSH — Core Steps

### Step 1: Generate SSH Key Pair (on Control Node)

```bash
ssh-keygen -t rsa -b 4096
```

What this does:
- `ssh-keygen` generates SSH keys
- `-t rsa` selects the RSA key type
- `-b 4096` creates a strong 4096-bit key

Result:
- Two files are created in `~/.ssh/`
  - `~/.ssh/id_rsa` → private key
  - `~/.ssh/id_rsa.pub` → public key

Notes:
- Default file location is usually correct
- You may set a passphrase:
  - Adds extra security
  - Requires entry when the key is used
  - Often skipped in labs for simplicity

---

### Step 2: Copy Public Key to the Server (Managed Node)

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
```

What this does:
- `ssh-copy-id` copies the public key to the remote server
- `-i ~/.ssh/id_rsa.pub` specifies the public key
- `user@host` is the remote username and IP/hostname

What happens internally:
- The public key is appended to:
  - `/home/user/.ssh/authorized_keys` on the target server

Important:
- The first time, it may ask for the server password (this is normal).
- After this step, SSH access should work without passwords

---

### Step 3: Test SSH Connection (No Password Expected)

```bash
ssh user@host
```

Expected behavior:
- Login succeeds without asking for a password
- SSH key authentication is working correctly

---

## Why Passwordless SSH Helps Ansible

When Ansible runs:
It needs to connect to each managed node repeatedly
Passwordless SSH enables:
- Fast, uninterrupted automation
- Non-interactive playbook execution
- Reliable multi-host operations

Without passwordless SSH, Ansible automation becomes impractical.

---

## Special Case: AWS EC2 (Key Pair Behavior)

AWS EC2 instances usually do **not** use username/password login.

Instead:
- AWS uses SSH key pairs by default

During EC2 creation:
- You select or create a **Key Pair**
- AWS places the public key on the instance automatically
- You download the private key as a `.pem` file

Result:
- The instance trusts the public key
- You authenticate using the `.pem` private key
- Access is passwordless by design

---

## Combining AWS `.pem` Keys with `ssh-copy-id`

Typical workflow:
- You already have an AWS private key (example: `aws-keypair.pem`)
- This key allows initial access to the instance
- You want to create a NEW local key pair (id_rsa / id_rsa.pub) for Ansible usage and copy its public key to the EC2 instances.

Conceptual steps:
1. Use the AWS `.pem` key to SSH into the instance initially
2. Generate a new SSH key pair on the control node
3. Copy the new Ansible public key to the EC2 instance
4. Use the new key for ongoing Ansible automation

Key idea:
- AWS key → initial secure access
- New SSH key → long-term automation access

In practice, the important idea is:
- Use the .pem key to perform the first secure connection
- Then install your new public key onto the managed nodes

---

## Example Lab Scenario (Two Managed Nodes on AWS)

Environment:
- Control Node
- Two EC2 managed nodes:
  - `web`
  - `database`

Each managed node:
- Has a public IP
- Has the AWS public key installed at launch
- Is accessible using the `.pem` private key (the matching .pem private key locally)

Goal:
- Generate a new SSH key pair on the control node
- Copy the new public key to both `web` and `database`
- Then SSH into both without password prompts (and without repeated manual friction)


# Ansible Vault — Encrypting Sensitive Data (Secrets Management)

## What is Ansible Vault?

**Ansible Vault** is a feature used to **encrypt sensitive data at rest** and **decrypt it only at runtime** when a playbook is executed.

Meaning:
- Secrets remain encrypted on disk
- Decryption happens only during playbook execution
- Encrypted files are unreadable if opened directly

---

## Why Ansible Vault Is Important

Automation workflows often require **secrets**, such as:
- AWS Access Key ID (`AWS_ACCESS_KEY_ID`)
- AWS Secret Access Key (`AWS_SECRET_ACCESS_KEY`)
- Passwords
- Tokens
- API keys

If these values are stored in plain YAML files:
- Anyone with access to the repository or server can read them

The goal:
- Store secrets in files
- Keep them unreadable unless the correct vault key is provided

---

## Main Use Case Example (AWS Credentials)

You may want to store AWS credentials in a file such as:
- `aws_credentials.yml`

Normally, this file would contain:
- `aws_access_key: ...`
- `aws_secret_key: ...`

These values must not be readable in plain text.  
Ansible Vault solves this problem.

---

## Vault Workflow (High Level)

1) Create a **Vault Password File** (your encryption key)  
2) Create an **Encrypted Variables File** using that password  
3) Include the encrypted file in a playbook using `vars_files`  
4) Run the playbook while providing the vault password file

---

## Step 1: Create a Vault Password File

Generate a strong random password and store it in a file.

```bash
openssl rand -base64 2048 > vault.pass
```

What this does:
- Generates a strong random value
- Stores it in `vault.pass`
- This file acts as the encryption/decryption key

Important:
- Without this file, vault-encrypted data cannot be decrypted

---

## Step 2: Create an Encrypted Variables File

### Option A: Create the File Encrypted (Recommended)

```bash
ansible-vault create aws_credentials.yml --vault-password-file vault.pass
```

Behavior:
- Opens an editor
- You enter sensitive values
- File is saved encrypted on disk

Example content before encryption:
```yaml
aws_access_key: AKXXXXXXXXXXXXXX
aws_secret_key: XXXXXXXXXXXXXXXX
```

After saving:
- File content is encrypted
- Not readable as plain YAML

---

### Option B: Encrypt an Existing YAML File

If the file already exists in plain text:

```bash
ansible-vault encrypt aws_credentials.yml --vault-password-file vault.pass
```

Difference:
- `create` → creates a new encrypted file
- `encrypt` → converts an existing file into an encrypted vault file

---

## Step 3: Use Encrypted Variables in a Playbook

Encrypted files are included like normal variable files.

Example playbook:

```yaml
---
- hosts: localhost
  connection: local
  vars_files:
    - aws_credentials.yml

  tasks:
    - name: Create a new IAM group
      amazon.aws.iam_group:
        name: AWSAdmins
        state: present
        aws_access_key: "{{ aws_access_key }}"
        aws_secret_key: "{{ aws_secret_key }}"
```

Explanation:
- `vars_files` loads the encrypted variables
- Variables are referenced normally using Jinja2 (`{{ }}`)

---

## Step 4: Run the Playbook (Decrypt at Runtime)

Because variables are encrypted, Ansible must be given the vault password file at runtime.

```bash
ansible-playbook playbook1.yml --vault-password-file vault.pass
```

Key behavior:
- Secrets are decrypted only during execution
- No manual decryption required
- Encrypted files remain protected on disk

---

## Important Context: Localhost Execution (AWS Use Case)

In AWS provisioning playbooks:
- Tasks interact with AWS APIs
- No SSH connection to managed nodes

Therefore playbooks often use:
```yaml
hosts: localhost
connection: local
```

Because you are calling AWS services using API calls, not connecting to a managed node via SSH.

---

## Practical Security Benefits

With Ansible Vault:
- Secrets remain encrypted at rest
- Playbooks can be shared safely
- Repository leaks do not automatically expose credentials
- Only users with the vault password file can decrypt sensitive data

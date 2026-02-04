# Inventory File + Ad-Hoc Commands — Core Concepts (DevOps Notes)

## Inventory Basics (Inventory File)

In Ansible, one of the first things to understand is the **Inventory File**.

### What is the Inventory File?
The **Inventory File** defines the **managed devices** (Managed Nodes) that Ansible controls.

It typically contains:
- IP addresses or hostnames
- Optional grouping (web servers, database servers, etc.)

Example scenario:
You manage two nodes:
- Web Server
- Database Server

Both are listed inside an inventory file so Ansible knows where to connect.

---

## Inventory Groups (Grouping Devices)

Inventory files support **grouping**, which allows targeted execution.

Example groups:
- `web`
- `db`

This enables:
- Running tasks only on web servers
- Running tasks only on database servers
- Running tasks on all servers when needed

Grouping prevents unintended changes to unrelated systems.

---

## Inventory File Format Example (INI Style)

A common inventory format uses **INI syntax**.

```ini
[web]
44.212.48.141 ansible_user=ubuntu

[db]
34.239.1.186 ansible_user=ubuntu
```

Meaning:
- `[web]` and `[db]` are group names
- `ansible_user=ubuntu` defines the SSH user
- IP addresses identify the target hosts

This avoids repeating SSH user information in every command.

---

### Why Grouping Matters

Grouping allows:
- Isolated operations per role
- Controlled execution scope
- Reduced operational risk

You can operate on a subset of infrastructure without affecting everything.
commands only on web servers or commands only on db servers or both.

---

## Ad-Hoc Commands (Quick One-Liners)

### Two Ways to Execute Tasks in Ansible

Ansible supports:
1. **Ad-Hoc Commands**
2. **Playbooks**

Ad-Hoc commands are used when:
- A single task is needed
- Writing a playbook is unnecessary
- Quick checks or actions are required

Examples:
- Ping hosts
- Check uptime
- Install a package once

---

## Ad-Hoc Command Structure

General format:

```bash
ansible [group_name | all] -i [inventory_file] -m [module] -a [arguments]
```

Components:
- `ansible`  
  CLI tool for ad-hoc execution

- `[group_name | all]`  
  Target hosts:
  - a specific group (`web`, `db`)
  - or `all` hosts

- `-i [inventory_file]`  
  Inventory file path (e.g. `hosts.ini`)

- `-m [module]`  
  Specifies which Ansible module to execute  
  Examples:
  - `ping`
  - `apt`
  - `copy`
  - `service`

- `-a [arguments]`  
  Module-specific parameters
  Example: which package name to install

---

## Default Inventory Location

If the inventory file is located in the default location at:

```bash
/etc/ansible/hosts
```

Then:
- `-i` is optional
- Ansible uses it automatically

In most lab setups, a project-local inventory file is preferred.

---

## Ad-Hoc Example 1: Ping Connectivity Test
Test connectivity to the web group:

```bash
ansible web -i hosts.ini -m ping
```

This verifies:
- SSH connectivity
- Ansible communication
- Control Node reachability

---

## Ad-Hoc Example 2: Check Uptime using a custom inventory file (Default Module)

```bash
ansible all -i hosts.ini -a "uptime"
```

Behavior:
- No module specified
- Ansible defaults to the `command` module

Equivalent to:
```bash
ansible all -i hosts.ini -m command -a "uptime"
```

---

## Ad-Hoc Example 3: Install Nginx Using `apt` module

```bash
ansible all -i hosts.ini -m apt -a "name=nginx state=present" --become
```

Explanation:
- Target: all hosts
- Module: `apt`
- Arguments:
  - `name=nginx` → package name
  - `state=present` → ensure installed
- `--become`:
  - execute with elevated privileges (sudo)

Result:
- If nginx is already installed → no change
- If nginx is missing → installed

This demonstrates **idempotent behavior**.

---

## Inventory + Ad-Hoc Practical Flow

### Step 1: Create Inventory File

Create `hosts.ini`:

```ini
[web]
44.212.48.141 ansible_user=ubuntu

[db]
34.239.1.186 ansible_user=ubuntu
```

---

### Step 2: Ping All Hosts

```bash
ansible all -i hosts.ini -m ping
```

Expected behavior:
- `SUCCESS` responses
- Confirms connectivity

---

### Step 3: Run Uptime on Web Group Only

```bash
ansible web -i hosts.ini -a "uptime"
```

Notes:
- Module not specified
- Default `command` module is used
- Output may show `changed` even though no configuration changed
- This is normal for command execution output

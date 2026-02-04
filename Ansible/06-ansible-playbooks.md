# Ansible Playbooks — Structure, Execution, Output, and Practical Patterns (DevOps Notes)

## What is an Ansible Playbook?

An **Ansible Playbook** is a YAML file that defines automation logic.

Core structure:
- **Playbook → Plays → Tasks → Modules**

Meaning:
- A playbook contains one or more **plays**
- Each play targets hosts and defines behavior
- Each play contains **tasks**
- Each task calls a **module** to perform an action

---

## Playbook Structure (Play → Tasks → Modules)

Playbooks are written in YAML and usually start with:

```yaml
---
```

Basic example: install and start Apache on the `web` group.

```yaml
---
- name: Install and Start Apache        # Play name shown in Ansible output
  hosts: web                            # Target the 'web' group from inventory
  become: yes                           # Use sudo / root privileges on remote hosts

  tasks:                               # List of tasks to execute
    - name: Install Apache              # Task title shown in output
      apt:                              # Use the apt module (Debian/Ubuntu)
        name: apache2                   # Package name to manage
        state: present                  # Ensure the package is installed

    - name: Start Apache                # Next task
      service:                          # Use service module to manage services
        name: apache2                   # Service name
        state: started                  # Ensure the service is running
        enabled: yes                    # Enable service to start on boot
```

---

## Line-by-Line Meaning (Core Fields)

- `- name: Install and Start Apache`
  - Play name
  - Displayed in output logs

- `hosts: web`
  - Target group from inventory
  - Ansible runs this play only on `[web]` hosts

- `become: yes`
  - Run tasks with sudo/root privileges
  - Required for package installation and service management

- `tasks:`
  - List of actions to execute on the target hosts

---

## Tasks (What a Task Is)

A **task** represents one action, such as:
- installing a package
- starting or stopping a service
- copying a file
- running a command

Task structure:
```yaml
- name: Task title
  module_name:
    option_1: value
    option_2: value
```

Rules:
- Each task starts with `-`
- Indentation is mandatory
- Tasks live under `tasks:`

---

## Modules Inside Tasks (Why Modules Matter)

The most important decision in a task is **which module to use**.

### `apt` Module (Package Management)

```yaml
- name: Install Apache
  apt:
    name: apache2
    state: present
```

Behavior:
- Use apt module
- Ensures `apache2` is installed
- If already installed → no change
- If missing → installs it

This demonstrates:
- declarative behavior
- idempotence

---

### `service` Module (Service Management)

```yaml
- name: Start Apache
  service:
    name: apache2
    state: started
    enabled: yes
```

Behavior:
- Service is running now (state: started)
- Service starts automatically on boot (enabled: yes)

---

## `present` vs `absent` (Install vs Remove)

Install:
```yaml
apt:
  name: apache2
  state: present
```

Remove:
```yaml
apt:
  name: apache2
  state: absent
```

Behavior:
- If state differs → Ansible changes it
- If state already matches → no action

This clearly shows idempotency.

---

## Writing Playbooks Correctly (Indentation Rules)

Indentation defines structure.

Rules:
- Use spaces (not tabs)
- Common standard: **2 spaces per level**
- Child items must be indented under their parent key

Concept:
- `tasks:` is a parent
- tasks are indented under it
- module options are indented again

Incorrect indentation breaks playbooks.

---

## Where to Get Module Syntax (Documentation Workflow)

Workflow:
- Decide what you want to manage
- Find the matching module in Ansible documentation
- Copy a documented example
- Adjust:
  - names
  - states
  - options

You do not guess module syntax.

---

## Executing Playbooks

General command:
```bash
ansible-playbook -i hosts.ini playbook1.yaml
```

Meaning:
- `ansible-playbook` → playbook execution command
- `-i hosts.ini` → inventory file
- `playbook1.yaml` → playbook to run

---

## Scope Control Using `hosts`

If a play contains:
```yaml
hosts: web
```

Then:
- Only `web` group hosts are targeted
- Other inventory groups are ignored

Scope is controlled inside the playbook itself.

---

## Understanding Playbook Output (OK / CHANGED / FAILED)

Each task returns a status:

### OK
- Desired state already met
- No change required

### CHANGED
- Ansible modified the system
- State was different before execution

### FAILED
- An error occurred
- Playbook stops unless errors are handled explicitly

---

## Why Recap Shows Extra `ok` Counts

At the end, Ansible prints a recap per host:
```
ok=2 changed=1 failed=0
```

Reason:
- Ansible runs **Gather Facts** automatically
- Fact gathering counts as a task

Example:
- 1 user task → ok=2
  - Gather Facts
  - Your task

- 2 user tasks → ok=3
  - Gather Facts
  - Task 1
  - Task 2

This is normal behavior.

---

## Practical Pattern: Build (Install/Start then Stop/Remove)

### Pattern 1: Install + Start

- Install package (`present`)
- Start and enable service

---

### Pattern 2: Stop + Remove

Reverse the setup:

```yaml
---
- name: Stop and Remove Apache
  hosts: web
  become: yes
  tasks:
    - name: Stop Apache
      service:
        name: apache2
        state: stopped

    - name: Remove Apache
      apt:
        name: apache2
        state: absent
```

Behavior:
- Stops the service
- Removes the package

Recap example:
- `ok=3` may appear due to:
  - Gather Facts
  - Stop task
  - Remove task

This pattern is common in real operational playbooks.

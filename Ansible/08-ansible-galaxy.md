# Ansible Galaxy — Discovering, Installing, Inspecting, and Using Community Roles (DevOps Notes)

## What is Ansible Galaxy?

Ansible Galaxy is a platform for sharing Ansible automation content, mainly:

- **Roles**
- (and also Collections)

The idea is similar to:
- **Docker Hub** for Docker images
- A central place to publish reusable automation
- A place to download automation built by others

Why this matters:
- You often do **not** need to build everything from scratch
- Many common tasks already have tested roles available

Example:
- You want to install Apache
- You search Ansible Galaxy
- You find existing Apache roles
- You install and use one directly

---

## Why Use Galaxy (Practical Value)

Galaxy provides:

### 1) Ready-made Roles
- Common tasks already automated:
  - Apache
  - Nginx
  - Users
  - Firewall
  - Docker
- You can reuse instead of rewriting

---

### 2) Speed and Reuse
- Saves time
- Reduces duplicated work
- Encourages standard automation patterns

---

### 3) Standard Role Structure
Galaxy roles usually follow the standard layout:
- `defaults/`
- `handlers/`
- `tasks/`
- `vars/`
- `templates/`
- `files/`
- `tests/`

This makes roles predictable and easy to understand.

---

### 4) Documentation
Most roles include documentation that explains:
- What the role does
- How to install it
- How to use it
- Which variables can be configured

---

## Galaxy Role Pages (What You See)

On a typical Galaxy role page, you will find:
- Role description
- Installation command
- Usage examples
- Configurable variables
- Link to the source repository (often GitHub)

This allows you to evaluate:
- What will be installed or changed
- How OS differences are handled
- Which defaults you can override

---

## Role Source Repository (Inspecting the Role)

Galaxy roles usually link to a source repository.

Inside the repository you can inspect:
- `defaults/`
- `handlers/`
- `tasks/`
- `vars/`
- `files/`
- `templates/`
- `tests/`

Opening `tasks/main.yml` shows the exact automation logic.

Galaxy roles are transparent:
- You can read the code
- You can understand and verify behavior
- Nothing is hidden

---

## Creating an Account and Publishing Roles (High Level)

You can create an Ansible Galaxy account and publish your own roles.

This enables:
- Team-wide reuse
- Public sharing
- Scalable automation practices

---

## Installing a Role from Ansible Galaxy

### Installation Command

```bash
ansible-galaxy role install <username>.<role_name>
```

Naming format:
- `<username>` → Galaxy namespace
- `<role_name>` → role name

This installs the role locally.

---

## Default Role Installation Location

By default, roles are installed into:
```text
~/.ansible/roles/
```

Full path example:
```text
~/.ansible/roles/<username>.<role_name>/
```

Important notes:
- `.ansible` is a hidden directory
- You must navigate to it explicitly

---

## Inspecting Installed Roles Locally

Typical workflow:

```bash
cd ~/.ansible/roles
ls
cd <username>.<role_name>
ls
ls tasks
cat tasks/main.yml
```

This allows you to inspect:
- How packages are installed
- How services are managed
- Which variables are used
- How OS detection is handled

---

## Using a Galaxy Role in Your Playbook

Once a role is installed, you reference it directly in the playbook.

Example:

```yaml
- name: Use Apache role from Galaxy
  hosts: web
  become: yes
  roles:
    - <username>.<role_name>
```

Behavior:
- Ansible loads the role from `~/.ansible/roles/`
- No local role folder is required
- The role runs as defined by its author

---

## Running the Playbook

Command remains the same:

```bash
ansible-playbook -i hosts.ini playbook1.yaml
```

If the role is referenced correctly:
- Tasks from the Galaxy role are executed
- Changes apply to the managed nodes
- Output shows task execution and status

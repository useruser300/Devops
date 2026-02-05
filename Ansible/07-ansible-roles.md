# Ansible Roles — Structure, Reusability, and Real Practical Usage (DevOps Notes)

## What are Ansible Roles?

Ansible Roles are a structured way to **organize automation logic** (playbooks) into:

- reusable components  
- modular units  
- clean folder-based structures  

Instead of placing everything inside one long playbook, roles allow automation to be split into logical sections.

Main benefits:
- Organized and structured
- Reusable across multiple playbooks
- Modular and extensible
- Easier to maintain
- Easier to share

Roles make automation:
- modular
- maintainable
- scalable

---

## Why Roles Exist (Core Problem They Solve)

Without roles, automation often becomes:
- a single large playbook
- difficult to read
- hard to maintain
- mixed responsibilities (tasks, files, variables, handlers)

Example problem:
- Copying files requires manual path handling
- Variables and tasks are mixed together
- Service restarts are embedded inline

Roles solve this by enforcing a **standard directory structure** and separation of concerns.

---

## Role Structure (Folder-Based Design)

A role is a directory that contains multiple subdirectories.  
Each subdirectory has a specific responsibility.

Most YAML-based folders contain a file named:
- `main.yml`

Important note:
- Not every folder contains `main.yml`
- `main.yml` exists mainly in:
  - `tasks/main.yml`
  - `handlers/main.yml`
  - `defaults/main.yml`
  - `vars/main.yml`
  - `meta/main.yml`

---

## Understanding Role Subfolders

When a role directory is created, it contains several standard folders.

### `tasks/`
- Contains the main automation logic
- Replaces the `tasks:` section in a playbook

File:
- `tasks/main.yml`

Used for:
- installing packages
- managing services
- running configuration steps

Example tasks:
- install Apache, Nginx
- configure firewall
- deploy application

---

### `vars/`
- Stores role variables with **high priority**

File:
- `vars/main.yml`

Behavior:
- Variables here override defaults
- Can still be overridden by playbook or inventory variables

Example:
- `apache_port: 80`

---

### `defaults/`
- Stores role variables with **lowest priority**

File:
- `defaults/main.yml`

Behavior:
- Used only if the variable is not defined elsewhere
- Easily overridden

Example:
- `default_nginx_port: 88`

Priority rule:
- inventory / playbook vars
- `vars/`
- `defaults/` (lowest)

---

### `files/`
- Stores static files
- Files are copied as-is to managed nodes

Examples:
- HTML files
- scripts
- configuration files
- Upload a ready-made `index.html` to /var/www/html/

Used with:
- `copy` module

Path behavior:
- Ansible automatically looks inside `files/`
- No full path required in tasks

---

### `handlers/`
- Contains tasks that run **only when notified**
- Used for conditional actions

Common use cases:
- restart a service after configuration change
- reload a service

File:
- `handlers/main.yml`

Key concept:
- Handlers run only if a task triggers them using `notify`

A handler is basically a task — like for example: “As soon as Apache gets installed, I want you to start Apache.”

This example shows how Ansible handlers are used to restart a service only when a change occurs.
Apache is restarted only if the configuration file is modified, avoiding unnecessary restarts.


```yaml
---
- hosts: all
  become: yes

  tasks:
    # Uses the yum module (RHEL-based systems: CentOS, Rocky, Alma, RHEL)
    - name: Install Apache
      yum:
        name: httpd
        state: present

    - name: Deploy Apache config
      copy:
        src: httpd.conf            # Copy config file from control node
        dest: /etc/httpd/conf/httpd.conf
      notify: restart apache      # Notify handler ONLY if the file changes

  handlers:
    # Handler runs only when notified
    - name: restart apache
      service:
        name: httpd
        state: restarted           # Restart Apache after config change
```

---

### `templates/`
- Stores **Jinja2 templates**
- Template files end with `.j2`

Used for:
- dynamic configuration generation
- variable-based config files

---

## Common Role Folders Summary

- `tasks/` → main automation steps  
- `files/` → static files  
- `handlers/` → conditional service actions  
- `templates/` → dynamic config files  
- `vars/` → high-priority variables  
- `defaults/` → low-priority variables  

---

## Roles and Ansible Galaxy

Roles are designed to be shared and reused.

**Ansible Galaxy**:
- Central repository for roles
- Similar to:
  - Docker Hub (for images)
  - GitHub (for code)

Usage:
- Publish roles
- Download community roles
- Reuse proven automation instead of reinventing

---

## `ansible-galaxy` Tool (Role Management)

The main tool for role and collection management is:
- `ansible-galaxy`

### Create a New Role

```bash
ansible-galaxy role init apache_web
```

Meaning:
- Initializes a new role
- Creates standard directory structure

Result:
- A directory named `apache_web`
- Contains:
  - `tasks/`
  - `files/`
  - `handlers/`
  - `templates/`
  - `vars/`
  - `defaults/`
  - additional metadata

---

## Practical Role Example: Moving Tasks from Playbook to Role

### Step 1: Existing Playbook
Tasks are written directly under `tasks:`  
Problem:
- Playbook grows large
- Hard to maintain

Basic example: install and start Apache on the `web` group.

```yaml
---
- name: Install and Start Apache
  hosts: web
  become: yes
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start Apache
      service:
        name: apache2
        state: started
        enabled: yes
```

---

### Step 2: Create Role Structure

```bash
ansible-galaxy role init apache_web
```

---

### Step 3: Move Tasks into `tasks/main.yml`

File:
- `apache_web/tasks/main.yml`

Example:
```yaml
- name: Install Apache
  apt:
    name: apache2
    state: present

- name: Start Apache
  service:
    name: apache2
    state: started
    enabled: yes
```

---

### Step 4: Use Role in Playbook

```yaml
- name: Install Apache on web servers
  hosts: web
  become: yes
  roles:
    - apache_web

```

Meaning:
- Execute all tasks defined inside the role
- Playbook becomes shorter and cleaner

---

### Step 5: Run Playbook

```bash
ansible-playbook -i hosts.ini playbook1.yaml
```

Behavior:
- Role tasks execute
- Changes apply to managed nodes

---

## Role Example 2: Using `files/` with `copy` Module

Goal:
- Copy a file from your control node to the web server using a role.

### Step 1: Create a file inside the role `files/` folder

File path:
- `apache_web/files/test.txt`

Example content:
```
hi from apache_web
```

---

### Step 2: Add a Copy Task inside tasks/main.yml

File:
- `apache_web/tasks/main.yml`

Use the copy module:

```yaml
- name: Copy test file to web server
  copy:
    src: test.txt
    dest: /tmp/test.txt   # destination path on the managed node
    owner: root           # sets the file owner on the managed node
    group: root           # sets the gruop owner on the managed node
    mode: "0644"          # sets file permissions on the managed node
```

Key idea (how `src` works inside roles):

- `src: test.txt`
  - You do **NOT** need a full path like `apache_web/files/test.txt`
  - When a task runs inside a role, Ansible automatically searches in the role’s `files/` directory
  - So Ansible resolves this automatically to:
    - `apache_web/files/test.txt`

Then:
- Ansible copies that file from the Control Node into the managed node.

---

### Step 3: Run Playbook Again

```bash
ansible-playbook -i hosts.ini playbook1.yaml
```

Expected result:
- The file is copied to the web server
- You see `changed` if the file did not exist or content was different 

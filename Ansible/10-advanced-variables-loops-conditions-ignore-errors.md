# Variables, Loops, Conditions, and Ignoring Errors (DevOps Notes)

## Why This Section Matters

When writing playbooks, common problems appear quickly:
- Tasks are repeated
- Values are hardcoded
- Small changes require rewriting playbooks

This section introduces **three core concepts** that make playbooks:
- flexible
- reusable
- clean and scalable

The three concepts are:
1) Variables  
2) Loops  
3) Conditions  

---

## 1) Variables (Reuse the Same Playbook with Different Values)

### Core Idea
Instead of writing a playbook that always installs **Apache**, you write it once and control behavior using variables.

Examples:
- Apache (`apache2`)
- Nginx (`nginx`)
- Any other package

You do that by replacing hardcoded values with variables, and then defining those variables in a separate file.

---

### Variable Syntax (Jinja2)

Variables are referenced using Jinja2 syntax:

```yaml
"{{ var_name }}"
```

Example:
```yaml
"{{ pkg }}"
```

---

### Using `vars_files`

Variables are commonly stored in separate files.

Playbook reference:
```yaml
vars_files:
  - vars.yml
```

Task usage:
```yaml
name: "{{ pkg }}"
```

---

### Example Playbook (Install Package Using Variable)

```yaml
---
- hosts: webservers
  become: yes

  vars_files:
    - vars.yml

  tasks:
    - name: Install web server
      apt:
        name: "{{ pkg }}"
        state: present
```

Here you define the variable value:
Example `vars.yml`:
```yaml
pkg: apache2
```

To switch to Nginx:
```yaml
pkg: nginx
```

Benefits:
- same playbook
- different result
- change happens in one place
You can define more than one variable in the vars file, and then reuse them across multiple tasks.


---

## 2) Loops (Run the Same Task for Multiple Items)

### Core Idea
Instead of duplicating tasks, loop over a list of items.

Instead of:
- install openssh
- install openssl

Use one task with a loop.
How it works
- Put name: "{{ item }}"
- Add loop: with the list of items
- Ansible will run the same task once per item

---

### Loop Example (Install Multiple Packages)

```yaml
---
- hosts: web
  become: yes

  tasks:
    - name: Install openssh and openssl
      ansible.builtin.apt:
        name: "{{ item }}"
        state: latest
      loop:
        - openssh-client
        - openssl
```

Execution behavior:
- First run → installs `openssh-client`
- Second run → installs `openssl`

Benefits:
- no duplicated tasks
- cleaner playbook
- easy to extend (edit the list only)

---

## 3) Conditions (Run Tasks Only When Needed)

### Core Idea
Sometimes tasks should run only when a condition is met.

Common cases:
- OS-specific tasks
- feature flags
- environment checks
- fact-based decisions

Ansible uses:
```yaml
when:
```

---

### Condition Example (Run Only on Debian)

```yaml
---
- hosts: web
  become: yes

  tasks:
    - name: Start Apache on Debian
      service:
        name: apache2
        state: started
      when: ansible_os_family == "Debian"
```

Important rules:
- `when` is at the same level as the module
- Applies only to that task

Behavior:
- Debian-based system → task runs
- Other systems → task is skipped

---

## Combined Example (Variables + Conditions)

```yaml
---
- hosts: web
  become: yes

  vars_files:
    - vars.yml

  tasks:
    - name: Install web server
      apt:
        name: "{{ pkg }}"
        state: present

    - name: Start web server on Debian
      service:
        name: apache2
        state: started
      when: ansible_os_family == "Debian"
```

`vars.yml`:
```yaml
pkg: apache2
```

---

## Practical Notes

1) **Variables reduce manual edits**  
Change one vars file instead of many playbooks.

2) **Loops prevent repetition**  
Use loops whenever the same task pattern repeats.

3) **Conditions enable smart behavior**  
Run tasks only when the environment matches.

4) **Facts are used in conditions**  
`ansible_os_family` is an Ansible fact.

5) **Output behavior**
- `changed` → system was modified
- `ok` → desired state already existed

---

## Ignoring Errors in Ansible Tasks — `ignore_errors`

### Core Idea

Ansible executes tasks sequentially:
- task 1 → task 2 → task 3

If a task **fails on a host**, Ansible **stops executing further tasks on that host** by default.

Sometimes you want the playbook to continue anyway (best-effort behavior).

---

### Why Use `ignore_errors`

Example workflow:
1) Install security prerequisites
2) Install Docker

If step (1) fails:
- step (2) should still run

Without `ignore_errors`, execution stops.

---

### How to Use `ignore_errors`

Add it to the task definition:

```yaml
- name: Install openssh and openssl
  ansible.builtin.apt:
    name: "{{ item }}"
    state: latest
  loop:
    - openssh
    - openssl
  ignore_errors: yes
- name: Check if Docker is installed
ansible.builtin.command: docker --version

```

Next tasks continue normally, even if the fisrt task fails.

---

### What `ignore_errors` Actually Does

- It does **not** fix errors
- It does **not** hide failures
- It only allows execution to continue

Use carefully:
- Useful for non-critical steps
- Dangerous if used to hide real failures

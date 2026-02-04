# YAML Basics — Core Concepts (DevOps Notes)

## Why YAML Matters in Ansible

Ansible **playbooks are written in YAML**.  
Before working with playbooks, YAML fundamentals must be understood because YAML defines **structure, hierarchy, and intent**.

YAML is also widely used across modern infrastructure tooling.

---

## What is YAML?

YAML is:
- a **human-readable configuration format**
- easy to read and write
- designed to represent structured data clearly

Commonly used with:
- Kubernetes
- Ansible

---

## YAML Document Start (`---`)

Most YAML files start with:

```yaml
---
```

Meaning:
- Marks the **start of a YAML document**
- Especially important when a file contains multiple YAML documents

---

## YAML Key-Value Pairs

Core format:
```yaml
key: value
```

Example:
```yaml
name: Ali
```

Important rules:
- A colon `:` is required
- A **space after the colon** is mandatory
- Keys are case-sensitive

---

## YAML Supported Data Types

### 1) Strings

Strings can be written in multiple valid forms:

```yaml
name: "Ali"
name: 'Ali'
name: Ali
```

All are valid YAML strings.

---

### 2) Integers (Numbers)

```yaml
age: 14
```

---

### 3) Boolean

```yaml
manager: True
```

Valid boolean values:
- `true` / `false`
- `True` / `False`

---

## YAML Data Types & Structures

### 1) Dictionary (Mapping)

A dictionary is a set of key-value pairs.

Example:
```yaml
employee:
  name: Ali
  age: 30
  manager: True
```

Key points:
- `employee` is the main key
- Its value is a **dictionary**
- Indentation defines hierarchy
  - Nested items are indented (commonly 2 spaces)
- Order does **not** matter:
  - `age` can appear before `name`

---

### 2) List (Sequence)

A list represents multiple items of the same type.

Example:
```yaml
skills:
  - Ansible
  - Docker
  - AWS
```

Key points:
- `skills` is the key
- The value is a **list**
- Each item:
  - starts with `-`
  - is indented under the key

This list represents items of the same type:
- skills or courses or tools

---

### 3) List of Dictionaries

Used when list items need structure.

Example:
```yaml
servers:
  - name: web01
    ip: 10.0.0.5
  - name: db01
    ip: 10.0.0.10
```

Key points:
- `servers` is a list
- Each list item is a **dictionary**
- Each dictionary contains structured attributes:
  - `name`
  - `ip`

Used when:
- simple lists are not enough
- structured objects are required
---

## Core YAML Rules to Remember

- Indentation is **mandatory**
- Spaces are used (not tabs)
- Structure is defined by indentation level
- Keys must be unique within the same scope
- YAML describes **data**, not logic

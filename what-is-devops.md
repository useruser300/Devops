# What DevOps Is

DevOps exists because development and operations used to work as separate teams with different responsibilities.

Before DevOps:
- Developers wrote the application.
- Operations teams ran the servers and deployed the application.
- When something failed:
  - Developers said the code was correct.
  - Operations said the servers were fine.
- Problems moved back and forth without clear ownership.

The real issue was:
- Manual processes
- Different goals (speed vs stability)
- No shared responsibility for production systems

---

## Why DevOps Exists

DevOps is **not a person** and **not a job title**.

DevOps is:
- A way of working
- A set of practices
- Shared responsibility between development and operations

The goal of DevOps is:
- Faster and safer delivery
- Fewer production issues
- Clear ownership of systems from code to production

---

## Core Idea of DevOps

The main idea of DevOps is to make applications:
- Easy to run
- Easy to deploy
- Easy to operate
- Easy to scale

An application should:
- Run the same way everywhere
- Not depend on manual setup
- Behave predictably in production

---

## The Environment Problem

Applications depend on:
- Programming languages
- Libraries
- Databases
- Web servers
- System configuration

Example:
- A PHP application needs PHP, MySQL, and Apache.
- A Python application may need Python, Django, and Nginx.

If each server is set up manually:
- Environments differ
- Bugs appear that are not in the code
- Deployments become slow and risky

---

## DevOps Responsibility

DevOps focuses on the **full system lifecycle**.

This includes:
- Preparing environments
- Managing dependencies
- Automating builds and deployments
- Running applications in production
- Monitoring and logging
- Handling failures and recovery
- Scaling systems when load increases
- Improving reliability and security

DevOps does not stop at deployment.

---

## Automation and Pipelines

DevOps relies heavily on automation.

Automation replaces:
- Manual setup
- Repeated steps
- Human error

Pipelines are used to:
- Build applications
- Test code
- Deploy systems
- Apply infrastructure changes

Once defined, the same process runs every time.

---

## Core DevOps Tools

You do not need every tool.  
Tools can change.  
Concepts do not change.

---

### Scripting
- Bash (Linux)
- PowerShell (Windows)

Used for:
- Automation
- System tasks
- Glue between tools

---

### Containers
- Docker

Used for:
- Packaging applications with their dependencies
- Running the same environment everywhere

---

### Configuration Management
- Ansible

Used for:
- Configuring servers
- Managing many machines the same way
- Reducing configuration differences

---

### CI/CD Systems
- Jenkins
- GitHub Actions
- GitLab CI/CD

Used for:
- Running automation pipelines
- Connecting code changes to deployments

---

### Orchestration and Infrastructure
- Kubernetes
- Terraform

Used for:
- Running containers at scale
- Managing infrastructure using code
- Creating and updating environments safely

---

### Cloud Platforms
- AWS
- Google Cloud (GCP)
- Microsoft Azure

Used for:
- Compute
- Storage
- Networking
- Scalable infrastructure

---

## Programming Knowledge in DevOps

DevOps engineers **do write code**.

But they usually write:
- Automation scripts
- Infrastructure as Code
- Pipelines
- Tooling and integrations

They usually do not write:
- Business logic
- Product features

Understanding programming is required to:
- Know how applications run
- Know what environments they need
- Debug production issues

---

## Summary

DevOps is a way of working that:
- Connects development and operations
- Uses automation instead of manual work
- Treats infrastructure as code
- Focuses on reliability, scalability, and operations

DevOps is about **building, running, and improving systems**, not just deploying them.

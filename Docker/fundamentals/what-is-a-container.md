# Docker Container — Core Concepts

## What is a Container?
A **Container** is an **isolated process** used to run a part of your application inside an environment that is independent from your machine and from other services.  
The core idea: each component of an application (Frontend / API / Database) runs inside its **own isolated environment**.

### Real-world example (multi-component application)
If you have a project that includes:
- React Frontend
- Python API
- PostgreSQL Database

Instead of installing Node, Python, and PostgreSQL on your machine and dealing with version conflicts and configuration issues,  
you run each component inside its own independent Container.

---

## Why do we use Containers?
Containers solve common problems such as:
- How can I make sure I’m using the same tool versions as the rest of the team?
- How can I ensure that CI/CD and production environments match the development environment?
- How do I prevent version conflicts or local software from affecting my application?

---

## Key Container Characteristics (Very Important)

### 1) Self-contained
Each Container includes everything it needs to run:
- Required system files
- Libraries
- Configuration
- Dependencies

**Without** relying on anything pre-installed on the host machine.

### 2) Isolated
A Container runs in strong isolation from:
- The host operating system
- Other Containers

This reduces interference and increases security and stability.

### 3) Independent
Each Container is managed independently:
- Removing one Container does not affect others
- Each service can be started, stopped, or restarted on its own

### 4) Portable
The same Container behaves the same on:
- Your local machine
- A data center server
- Any cloud environment

This greatly reduces the “it works on my machine” problem.

---

## Containers vs Virtual Machines (VMs)

### Virtual Machines in short
A **VM** is a **full operating system**, including:
- Its own kernel
- Hardware drivers
- Programs
- Applications

Running a VM just to isolate a single application results in **significant overhead**.

### Containers in short
A **Container** is:
- An **isolated process**
- Bundled with only the files it needs to run

Most importantly: **multiple Containers share the same host kernel**,  
which allows more applications to run on fewer resources.

---

## Using Containers Together with VMs (Common Scenario)
In cloud environments, servers are usually **VMs**.  
However, instead of running one application per VM:
- You run multiple Containers on the same VM
- This increases **resource utilization**
- And reduces **costs**

---

## Quick Lab: Running Your First Container (docker/welcome-to-docker)

### Method 1: Using Docker Desktop (GUI)
1) Open Docker Desktop  
2) In the search bar, type:
   - welcome-to-docker
3) Click **Pull** to download the image  
4) Click **Run**  
5) In Optional settings:
   - Container name: welcome-to-docker
   - Host port: 8080
6) Click **Run** to start the Container

**Result:** You successfully ran your first Container 

### Accessing the application (Port Mapping)
You exposed a port from inside the Container to your local machine:
- The service inside the Container listens on a port (for example, 80)
- You mapped it to port 8080 on your machine

You can access it via:
- http://localhost:8080

---

### Method 2: Using the Command Line (CLI)

#### Run a Container and publish a port
```bash
docker run -d -p 8080:80 docker/welcome-to-docker
```

**Explanation of options:**
- -d : Run in detached mode (background)
- -p 8080:80 : Map host port 8080 to container port 80
- docker/welcome-to-docker : Image name

Note: The output of this command is the full **Container ID**.

---

## Checking Running Containers
```bash
docker ps
```
Displays only **running containers**.

### Show all containers (including stopped ones)
```bash
docker ps -a 
```
---

## Understanding Ports (Critical DevOps Concept)

Containers are isolated by default, so accessing services inside them requires:
- Publishing ports
- Or using container networking

In this example:
- The service inside the Container runs on port 80
- You exposed it on your machine via port 8080
- Therefore, you access it at: http://localhost:8080

---

## Stopping a Container

### 1) Get the Container ID or name
```bash
docker ps
```

### 2) Stop the Container
```bash
docker stop <container-id-or-name>
```

### Important note (ID shortening)
You do not need the full Container ID — only a unique prefix:
```bash
docker stop a1f
```    

---

## Extra Skill: Exploring Container Files (Docker Desktop)

If you are using Docker Desktop:
- Go to the Containers view
- Select the Container
- Open the Files tab
- Browse the isolated filesystem inside the Container

---

## DevOps Summary
- A Container = isolated process + required runtime files
- Goal: consistent environments everywhere, fewer conflicts, high portability
- More efficient than VMs for isolating single applications
- Port publishing (-p) is the key to exposing containerized services to your machine

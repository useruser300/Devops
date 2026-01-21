# What is Docker? 

## 1. What is Docker?
Docker is an open platform used to **build, ship, and run applications**.

Docker helps you separate your **application** from the **infrastructure**, so you can deliver software faster and more reliably.

With Docker, you can manage your infrastructure in the same way you manage your code.

---

## 2. The Docker Platform
Docker allows you to package and run applications in a **lightweight isolated environment** called a **container**.

A container:
- Is lightweight
- Runs independently
- Includes everything the application needs (code, libraries, dependencies)
- Works the same way on every machine

This means:
- No “it works on my machine” problem
- Easy sharing between developers
- Same behavior in development, testing, and production

---

## 3. How Docker Is Used in Practice
Docker helps manage the **full lifecycle** of applications:

- Developers build applications using containers
- Containers become the unit for testing and sharing
- The same container is deployed to production
- This works the same on:
  - Local servers
  - Cloud providers
  - Hybrid environments

---

## 4. What Can I Use Docker For?

### Fast and Consistent Application Delivery
Docker makes development faster by using **standardized environments**.

Typical workflow:
- Developers write code locally
- They share applications using Docker containers
- Containers are pushed to test environments
- Automated and manual tests are run
- Bugs are fixed and redeployed easily
- Final image is pushed to production

This fits perfectly with **CI/CD pipelines**.

---

### Responsive Deployment and Scaling
Docker containers are **portable** and can run anywhere:
- Developer laptop
- Physical servers
- Virtual machines
- Cloud platforms

Containers are easy to:
- Start
- Stop
- Scale up
- Scale down  

based on business needs, almost in real time.

---

### Running More Workloads on the Same Hardware
Docker is faster and lighter than traditional virtual machines.

Benefits:
- Better use of server resources
- Lower costs
- Ideal for high-density environments
- Great for small and medium-sized systems

---

## 5. Docker Architecture
Docker uses a **client-server architecture**.

Components:
- **Docker Client**: where you type commands like `docker run`
- **Docker Daemon (dockerd)**: does the real work (builds images, runs containers)
- Communication happens through a **REST API**
- Client and daemon can run on:
  - The same machine
  - Different machines (remote Docker host)

Docker Compose is another client that helps manage **multi-container applications**.

---

## 6. Docker Daemon
The Docker daemon:
- Listens for Docker API requests
- Manages:
  - Images
  - Containers
  - Networks
  - Volumes
- Can communicate with other daemons to manage services

---

## 7. Docker Client
The Docker client:
- Is the main interface for users
- Sends commands to the Docker daemon
- Uses the Docker API
- Can connect to multiple Docker daemons

---

## 8. Docker Desktop
Docker Desktop is an easy-to-install application for:
- macOS
- Windows
- Linux

It includes:
- Docker daemon
- Docker CLI
- Docker Compose
- Kubernetes
- Credential helper tools

---

## 9. Docker Registries
A Docker registry stores Docker images.

- **Docker Hub** is the default public registry
- You can also use private registries

Common commands:
- `docker pull` → download an image
- `docker push` → upload an image

---

## 10. Docker Objects

### Images
- An image is a **read-only template**
- Used to create containers
- Usually based on another image (for example Ubuntu)
- Built using a **Dockerfile**
- Each Dockerfile instruction creates a **layer**
- Only changed layers are rebuilt → fast and efficient

---

### Containers
- A container is a **running instance of an image**
- You can:
  - Start, stop, delete containers
  - Connect them to networks
  - Attach storage
- Containers are isolated by default
- When a container is removed, data is lost unless stored in persistent storage

---

## 11. Example: docker run
```bash
docker run -i -t ubuntu /bin/bash
```

### What happens:

1. Docker checks if the Ubuntu image exists locally  
2. If not, it pulls it from the registry  
3. A new container is created  
4. A writable layer is added  
5. A network interface and IP address are assigned  
6. `/bin/bash` is started interactively  
7. When you exit, the container stops but is not deleted  

---

## 12. The Underlying Technology

Docker is written in **Go**.

It uses Linux kernel features such as:

- **Namespaces** for isolation  

Each container runs in its own isolated environment with limited access to the host system.

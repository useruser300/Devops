# Docker Learning Roadmap

## Learning Path Overview (Phases)

A clear step-by-step roadmap is organized into phases:

1. Phase 1: Docker Fundamentals  
2. Phase 2: Building Your Own Images  
3. Phase 3: Docker Networking & Data Persistence  
4. Phase 4: Multi-Container Apps  
5. Phase 5: Advanced  
6. Moving Beyond Docker  

---

## Prerequisites (Before You Start)

Before starting with Docker, you should have three foundations:

- Command Line Basics: basic terminal usage, navigating directories, running commands  
- Conceptual Knowledge: understanding applications, understanding servers, how software environments work  
- Programming Fundamentals: basic knowledge of at least one programming language (any language is fine)  

---

## Phase 1 — Docker Fundamentals

### 1) What Docker Is Solving (The “it works on my machine” problem)

The core idea: the problem is not only code. The problem is that the environment differs.

Example:
- A Node.js application runs locally with Node version 14 installed
- The production server runs Node version 16
- The application works perfectly locally, but breaks after deployment because of environment differences

Docker solves this by:
- Packaging the application with its entire environment: dependencies, configurations, everything it needs
- Creating a single container that runs exactly the same way anywhere Docker is installed

So Docker solves the problem of making applications run the same everywhere across environments, because Docker packages everything the application needs—application code, libraries, and dependencies—into standardized containers. This eliminates the “it works on my machine” problem across local development, testing, and production environments.

A useful mental shift:  
When you stop worrying about environment setup and start focusing on what your application actually does.

---

### 2) Core Concepts You Must Understand (WHAT + WHY)

Start by understanding “What and Why” first:

- What are containers?  
  Containers are lightweight, portable packages that include everything needed to run an application.

- Why do we need containers?  
  They solve environment consistency issues, dependency conflicts, and deployment problems.

- VMs vs Containers  
  Understand the differences in resource usage, startup time, and isolation.

#### Docker Architecture (Basic Architecture)

You need a clear model of how these parts work together:
- Docker Engine
- Images
- Containers
- How they interact as a system

#### Container Lifecycle

A container goes through a lifecycle:

Create → Start → Running → Stop → Remove  

Understanding this helps you reason about why run differs from start, and why rm deletes containers (not images).

#### Image vs Container (Most Important Distinction)

A simple mental model:
- Image = recipe/blueprint (static)
- Container = running version (the app is alive and working)

You can create many containers from one image (like making multiple cakes from the same recipe).

---

### 3) Installation & First Test

Validate that Docker is correctly installed:

```bash
docker --version
```

```bash
docker run hello-world
```

What this confirms:
- Docker Engine is working
- Pulling an image works
- Running a container works

---

### 4) Public Images & Docker Hub (Huge Value)

A major advantage of Docker: you don’t need to create images for common services yourself.

Examples of official images:
- Databases: MySQL, PostgreSQL, MongoDB, Redis, Elasticsearch
- Message brokers: RabbitMQ, Kafka
- Web servers: Nginx, Apache

A central idea:  
A large set of these images is stored in public repositories, with Docker Hub being the most widely used public registry. It functions like a centralized place to discover and pull container images.

#### Example: Run PostgreSQL Without Installing It Locally

```bash
docker pull postgres
```

```bash
docker run -e POSTGRES_PASSWORD=mysecretpassword -p 5000:5000 postgres
```

Option explanations:
- docker pull postgres  
  Downloads the image to your machine.

- docker run ... postgres  
  Creates and starts a container from the image.

- -e POSTGRES_PASSWORD=...  
  Sets an environment variable inside the container (here: PostgreSQL password).

- -p 5000:5000
  Port mapping:
  - left side = host (your machine)
  - right side = container (inside the container)

Result:  
A working database starts in seconds without installing PostgreSQL on the host OS.

---

### 5) Get Hands-On with Docker Commands (70–80% of Daily Usage)

If you can:
- pull an image
- run it locally
- access the service
- stop and remove containers
- list containers and images  

then you have mastered the most fundamental practical basics.

Core commands:

```bash
docker pull nginx
```

```bash
docker run -d -p 8080:80 nginx
```

```bash
docker ps
```

```bash
docker stop container_id
```

```bash
docker rm container_id
```

```bash
docker images
```

Option explanations:
- -d (Detached)  
  Runs the container in the background and returns control to your terminal.

- -p 8080:80 (Port mapping)  
  Makes the service inside the container (port 80) reachable from your host on port 8080.

- docker ps  
  Lists running containers only.

- docker images  
  Lists images stored locally.

Practical recommendation:  
Start with a lightweight public image like Nginx or Redis because it is easy to validate and interact with.

---

## Phase 2 — Building Your Own Images

This phase is the shift from using ready-made images to building your own image from your application.

What you need here:
- Images vs containers
- Dockerfile syntax (FROM, RUN, COPY, WORKDIR, EXPOSE, CMD)
- Image layers
- Build context
- Image tagging
- Dockerfile best practices (efficient, maintainable)

---

### 1) Dockerfile (Your Recipe / Blueprint)

A Dockerfile defines how a custom image is built.

Node.js example:

```dockerfile
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

Explanation of each instruction:

- `FROM node:14-alpine`  
  Specifies the base image (OS + runtime). Alpine is usually smaller and lightweight.

- `WORKDIR /app`  
  Sets the working directory inside the container; following commands run relative to this path.

- `COPY package*.json ./`  
  Copies dependency files into the image (often used to improve build caching).

- `RUN npm install`  
  Executes a command during image build to install dependencies inside the image.

- `COPY . .`  
  Copies the rest of the application into the image.

- `EXPOSE 3000`  
  Documents which port the container uses.

- `CMD ["npm", "start"]`  
  Defines what runs when the container starts.

Key insight:  
Each instruction creates a new image layer, building upon the previous layers in sequence.  
Layers enable efficient builds and image sharing.

---

### 2) Build and Run Your Image

```bash
docker build -t my-node-app .
```

```bash
docker run -p 3000:3000 my-node-app
```

Option explanations:

- `docker build`  
  Builds an image from a Dockerfile.

- `-t my-node-app`  
  Adds a tag (name) to the built image.

- `.`  
  The build context: Docker can access files within this directory during build.

- `docker run -p 3000:3000`  
  Maps the container port to the host port.

What happens during build:  
Docker creates a layered filesystem; each Dockerfile instruction becomes a layer.

What happens during run:  
Docker launches a container from the image, maps ports, and executes the CMD instruction.


---

## Phase 3 — Networking & Data Persistence

This phase is required for production-ready containerized applications: multi-container communication and persistent data.

---

### A) Docker Networking

What you need here:

- Container networking basics: how containers communicate with each other and with the outside world
- Docker network types: bridge, host, overlay networks and when to use each
- Port mapping: exposing container services to the host
- Container-to-container communication: using container names as hostnames

---

#### Example: Frontend communicating with a backend API

```bash
docker network create my-network
```

```bash
docker run -d --name api --network my-network my-backend-image
```

```bash
docker run -d --name frontend --network my-network -p 8080:80 my-frontend-image
```

Option explanations:

- `docker network create my-network`  
  Creates a virtual Docker network (often a bridge network).

- `--name api`  
  Assigns a container name; inside the network it becomes the hostname.

- `--network my-network`  
  Connects the container to that network.

- `-p 8080:80`  
  Exposes the frontend container to the host on port 8080.

Result:  
The frontend container can communicate with the backend by using `api` as the hostname because both are in the same network.

---

### B) Data Persistence (Volumes)

#### The core problem

Containers are ephemeral (temporary by design).  
If a database stores data inside the container filesystem, removing the container destroys the data.

---

#### The solution: Volumes

Volumes store data outside containers and can be reattached when containers are recreated.

A core principle:  
Docker manages the runtime environment; data persistence must be handled separately, and volumes provide the interface for that persistence.

---

#### What you need to learn:

- How data persistence works in Docker
- Volume types: named volumes, bind mounts, tmpfs mounts
- Volume management: creating, using, and cleaning up volumes

---

#### Example: Create a volume and use it with a database

```bash
docker volume create my-data
```

```bash
docker run -d --name mysql -v my-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password mysql
```

Option explanations:

- `docker volume create my-data`  
  Creates a persistent storage area managed by Docker on the host.

- `-v my-data:/var/lib/mysql`  
  Mounts the named volume into the container path where MySQL stores its data.

- `-e MYSQL_ROOT_PASSWORD=password`  
  Sets the root password through an environment variable.

- `--name mysql`  
  Assigns a stable container name for easier management and networking.

- `-d`  
  Runs in detached mode.

Key result:  
Even if you delete the container, the data survives in the volume and can be reused by a new container attached to the same volume.

---

## Phase 4 — Docker Compose

Manually typing many Docker commands becomes repetitive and error-prone.  
Docker Compose provides a declarative configuration file for multi-container setups, enabling reproducibility and consistency as configuration-as-code.

---

### What you need to know here:

- Infrastructure as Code: define the entire stack in YAML
- Compose file structure: services, networks, volumes, environment variables
- Service dependencies: `depends_on` for startup ordering
- Environment configuration: dev / staging / prod differences
- Scaling services: multiple instances
- Commands: up, down, logs, exec, scaling operations

---

### Example `docker-compose.yml`

```yaml
version: '3'
services:
  database:
    image: postgres:13
    environment:
      - POSTGRES_PASSWORD=password
    volumes:
      - db-data:/var/lib/postgresql/data

  api:
    build: ./api
    depends_on:
      - database
    environment:
      - DATABASE_URL=postgres://postgres:password@db:5432/postgres

  frontend:
    build: ./frontend
    ports:
      - "8080:80"
    depends_on:
      - api

volumes:
  db-data:
```

---

### Key parts and their meaning:

- `services`: defines each containerized component
- `image: postgres:13`: uses a specific version tag
- `environment`: injects environment variables into the container
- `volumes`: mounts persistent storage for stateful services
- `build: ./api`: builds an image from a Dockerfile in that directory
- `depends_on`: controls startup order
- `ports: "8080:80"`: maps host-to-container ports
- top-level `volumes`: defines a named volume

---

### Compose commands

```bash
docker-compose up -d
```

```bash
docker-compose down
```

Option explanations:

- `up -d` starts the whole stack in detached mode
- `down` stops services and cleans up related resources

A major convenience:  
Compose creates a network for the defined services and manages cleanup for the environment when services are stopped or removed.

---

## Phase 5 — Advanced

This phase focuses on production readiness: secure, efficient, maintainable images and operational practices beyond “just making containers run.”

---

### What you need to cover:

- Security fundamentals: running as non-root user, scanning vulnerabilities
- Image optimization: multi-stage builds, minimizing layers, choosing base images
- Resource management: memory and CPU limits
- Health checks: container health and automatic restarts
- Logging strategies: centralized logging and log management
- Configuration management: environment variables and secrets
- Image versioning: semantic versioning and tagging strategies

---

## Important Best Practices (With the Reason)

### 1) Use Specific Image Tags (Avoid `latest`)

Bad:
```dockerfile
FROM node:latest
```

Good:
```dockerfile
FROM node:18.17-alpine
```

Reason:
- `latest` can change without warning
- A rebuild or restart may pull a different image
- A previously working application may suddenly break due to breaking changes in the base image

---

### 2) Minimize Image Layers (Combine RUN Commands)

```dockerfile
RUN apt-get update && \
    apt-get install -y curl vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

Reason:
- Each RUN creates a new layer
- More layers often means a larger image
- Larger images are slower to download
- Carrying unnecessary tools increases attack surface

---

### 3) Multi-Stage Builds

```dockerfile
# Build stage
FROM node:14 AS build
WORKDIR /app
COPY . .
RUN npm ci && npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
```

Core idea:
- Use a larger image to build the app (tools available)
- Copy only the final output to a clean minimal runtime image

Benefits:
- Dramatically smaller image sizes (example: 1 GB down to <100 MB)
- Faster deployments
- Lower storage cost
- Fewer security issues due to fewer tools and smaller attack surface

---

### 4) Do Not Run as Root

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

Reason:
- Running as root grants high privileges inside the container
- If compromised, the attacker gains powerful access
- Using a dedicated non-root user restricts permissions and reduces impact

---

### 5) Scan Images for Vulnerabilities Regularly

```bash
docker scout cves node:18.17-alpine
```

Reason:
- An image may be secure today and insecure tomorrow
- New vulnerabilities are discovered continuously
- Scanning compares your image against an updated database of known issues
- Scanning can be integrated into CI/CD pipelines to catch issues before production

---

## Docker Registry + CI/CD Integration (Workflow Integration)

After mastering production practices and core Docker concepts, the next upgrade is integrating Docker into a development and deployment workflow by:

- storing images in registries
- automating build and deployment through CI/CD pipelines

Automation reduces human error because steps are executed the same way every time.

---

### What you need to know:

- Container registries: public vs private (Docker Hub, AWS ECR, GitHub Container Registry)
- CI/CD integration: execute Docker commands through pipeline-as-code
- Environment promotion: moving images through dev → staging → production
- Registry security: access control, image signing, vulnerability scanning

---

## Common Workflow (Detailed Steps)

A complete sequence:

### 1) Development Phase
A developer writes an application locally and may pull dependency images (e.g., MongoDB) from Docker Hub for local containers.

### 2) Version Control
The developer commits code changes to Git (GitHub / GitLab), triggering CI/CD.

### 3) CI/CD
The CI server (Jenkins / GitHub Actions) runs a pipeline:
- run tests and checks
- build a Docker image from source code using a Dockerfile

### 4) Docker Image Build
The application and its dependencies are packaged into a Docker image (standalone executable package).

### 5) Push to Private Repository
The built image is pushed to a private registry (AWS ECR, GitHub Container Registry, private registry).

### 6) Deployment Phase
The deployment server pulls:
- the new app image from the private registry
- external dependency images (e.g., MongoDB) from Docker Hub

### 7) Final Setup
The app image and dependency images run together as containers in a production-like environment.

---

## GitHub Actions Example

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .

      - name: Push to registry
        run: |
          docker tag myapp:${{ github.sha }} myregistry.com/myapp:${{ github.sha }}
          docker push myregistry.com/myapp:${{ github.sha }}
```

Key points:
- `${{ github.sha }}` creates a unique tag per commit
- `docker tag` renames the local image for the target registry path
- `docker push` uploads the image to the registry on each commit

---

## Moving Beyond Docker (Orchestration)

Modern projects often follow **microservices architecture**:

- One container per microservice
- Additional containers for databases, message brokers, and supporting services

At scale, managing many containers becomes difficult with Docker alone or even Docker Compose.

---

### As containerized applications grow, you need:

- automatically restart failed containers
- scale up and down based on load
- rolling updates with zero downtime
- load balancing across instances

---

### Key distinction:

- **Docker**: how to package and run containers
- **Kubernetes**: how to run containers at scale, reliably, and in production

---

## Docker Compose vs Orchestration

### Docker Compose is excellent for:

- local development
- simple staging
- small applications (2–3 services)
- proofs of concept and demos

---

### You need orchestration when you have:

- multiple environments with different scaling needs
- applications with 5+ services
- rolling deployments
- auto-scaling requirements
- complex networking or load balancing

---

## Other Orchestration Options

- Kubernetes (most popular)
- Docker Swarm (simpler than Kubernetes but has critical limitations)
- Cloud services:
  - AWS ECS
  - Google Cloud Run
  - Azure Container Instances
- Managed Kubernetes:
  - AWS EKS
  - Azure AKS
  - Google GKE

These services handle infrastructure complexity so teams can focus on building applications.


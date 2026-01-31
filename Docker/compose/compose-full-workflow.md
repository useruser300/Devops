# Docker Compose — Multi-Service Environment (MongoDB + Mongo Express + Node.js App)

## Overview
Docker Compose is used to define and run **multi-container applications** using a single declarative YAML file.  
Instead of manually running multiple `docker run` commands and managing networks and configuration across containers, Compose provides a clean way to manage an entire stack as one unit.

---

## Why Docker Compose is Used
In real-world systems, applications usually require multiple services to run together, such as:
- Databases
- Admin interfaces
- Backend APIs
- Web applications

These services often depend on each other, and their configuration needs to remain consistent across environments.  
Docker Compose simplifies this by keeping everything in one configuration file and allowing all services to be started and managed together.

**Without Compose:**
- you create networks manually
- you run each container with long `docker run` commands
- stopping/restarting/cleaning up 10–20 services becomes tedious

---

## Manual Multi-Container Setup (Docker CLI Approach)

### 1) Create a Dedicated Docker Network
A dedicated Docker network allows containers to communicate using container/service names as hostnames inside an isolated network.

```bash
docker network create mongo-network
docker network ls
```

**Options (simple explanation):**

* `docker network create` → creates a new Docker network
* `mongo-network` → the network name (custom name)
* `docker network ls` → lists all Docker networks

---

### 2) Start a MongoDB Container

This container exposes MongoDB on port `27017` and initializes a root user using environment variables.

```bash
docker run -d \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=supersecret \
  --network mongo-network \
  --name mongodb \
  mongo
```

**Options (simple explanation):**

* `docker run` → creates and starts a container from an image
* `-d` → runs the container in detached mode (background)
* `-p 27017:27017` → port mapping (`HOST_PORT:CONTAINER_PORT`)
* `-e KEY=VALUE` → sets an environment variable inside the container
* `MONGO_INITDB_ROOT_USERNAME=admin` → sets MongoDB root username
* `MONGO_INITDB_ROOT_PASSWORD=supersecret` → sets MongoDB root password
* `--network mongo-network` → attaches the container to the `mongo-network` network
* `--name mongodb` → gives the container a fixed name (`mongodb`)
* `mongo` → the image name used to create the container

---

### 3) Start a Mongo Express Container (MongoDB Web UI)

Mongo Express connects to MongoDB internally using the container name `mongodb` inside the Docker network.

```bash
docker run -d \
  -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=supersecret \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  --network mongo-network \
  --name mongo-express \
  mongo-express
```

**Options (simple explanation):**

* `-d` → runs the container in detached mode (background)
* `-p 8081:8081` → exposes mongo-express on `http://localhost:8081`
* `-e KEY=VALUE` → sets an environment variable inside the container
* `ME_CONFIG_MONGODB_ADMINUSERNAME=admin` → MongoDB admin username for mongo-express
* `ME_CONFIG_MONGODB_ADMINPASSWORD=supersecret` → MongoDB admin password for mongo-express
* `ME_CONFIG_MONGODB_SERVER=mongodb` → MongoDB hostname inside the Docker network (`mongodb` is the container name)
* `--network mongo-network` → attaches the container to the same network as MongoDB
* `--name mongo-express` → gives the container a fixed name (`mongo-express`)
* `mongo-express` → the image name used to create the container

---

### 4) Validate the Setup

Mongo Express becomes available on:

* `http://localhost:8081`

If authentication is required, credentials can be verified from logs:

```bash
docker logs <container_id_of_mongo-express>
```

**Options (simple explanation):**

* `docker logs` → prints the container logs (startup messages + errors)
* `<container_id_of_mongo-express>` → the container ID of mongo-express (get it from `docker ps`)

---

## Essential Docker Commands for Container Lifecycle
Common commands used to inspect and manage running containers and networks:

```bash
docker ps
docker stop <container>
docker rm <container>
docker network rm <network>
docker logs <container>
```

---

## Why Docker Compose
Managing multi-container applications using only `docker run` does not scale well.

When the number of services grows (10+ services), you typically face:
- repeated long `docker run` commands
- configuration duplication across multiple services
- higher risk of human errors when changing ports or environment variables
- time-consuming cleanup and restart operations

Docker Compose solves this by defining the entire stack as **Infrastructure as Code** inside a single YAML configuration.

---

## Docker Compose Configuration Model
Docker Compose provides a YAML-based format to describe:
- which services must run
- which ports to expose
- which environment variables to inject
- which dependencies exist between services

The key advantage is that all runtime configuration becomes part of the project repository as code.

---

## Compose File Basics
- `version`: compose file format version
- `services`: list of services (each service becomes a container)
- per service:
  - image or build
  - ports
  - environment
  - depends_on (startup order)

---

## Compose Example: MongoDB + Mongo Express
This is a minimal Compose file that runs MongoDB together with Mongo Express.

Security note: do not commit real credentials into GitHub. Use variables or `.env`.

```yaml
version: "3.1"

services:
  mongodb:
    image: mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: supersecret

  mongo-express:
    image: mongo-express
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: admin
      ME_CONFIG_MONGODB_ADMINPASSWORD: supersecret
      ME_CONFIG_MONGODB_SERVER: mongodb
    depends_on:
      - mongodb
```

---

## Commands to Run This Stack (MongoDB + Mongo Express)

### 1) Start services (foreground)
```bash
docker compose -f docker-compose.yaml up
```

### 2) Start services (detached / background)
```bash
docker compose -f docker-compose.yaml up -d
```

### 3) Verify containers are running
```bash
docker compose -f docker-compose.yaml ps
```

### 4) View logs (all services)
```bash
docker compose -f docker-compose.yaml logs -f
```

### 5) View logs (single service)
```bash
docker compose -f docker-compose.yaml logs -f mongodb
docker compose -f docker-compose.yaml logs -f mongo-express
```

### 6) Stop services (keep containers)
```bash
docker compose -f docker-compose.yaml stop
```

### 7) Start again after stop (reuse same containers)
```bash
docker compose -f docker-compose.yaml start
```

### 8) Stop + remove containers + remove network (full cleanup)
```bash
docker compose -f docker-compose.yaml down
```

### 9) Remove everything including volumes (data loss!)
```bash
docker compose -f docker-compose.yaml down -v
```

---

## Key Point: Networking Is Automatic
With Compose you usually do not need:
- `docker network create ...`
- `--network ...`

Compose automatically creates a shared network for all services in the file.

---

## Environment Variables and Secure Configuration
Hardcoding credentials inside a repository is not recommended.

Instead, Compose supports environment-based placeholders:

```yaml
environment:
  - MONGO_INITDB_ROOT_USERNAME=${MONGO_ADMIN_USER}
  - MONGO_INITDB_ROOT_PASSWORD=${MONGO_ADMIN_PASS}
```

### Supplying Variables (Terminal Session)
```bash
export MONGO_ADMIN_USER="admin"
export MONGO_ADMIN_PASS="supersecret"
```

### Supplying Variables (.env file)
Create a `.env` file next to your compose file:

```env
MONGO_ADMIN_USER=admin
MONGO_ADMIN_PASS=supersecret
```

Add `.env` to `.gitignore` when it contains sensitive values.

---

## Running a Full Stack (App + MongoDB + Mongo Express)
Docker Compose can run both third-party services and custom applications inside the same network.

This configuration includes:
- Node.js app on port 3000
- MongoDB on port 27017
- Mongo Express on port 8081
- credentials injected via environment variables

```yaml
version: "3"

services:
  my-app:
    # build: .
    image: docker-hub-user/image-name:image-tag
    ports:
      - "3000:3000"
    environment:
      - MONGO_DB_USERNAME=${MONGO_ADMIN_USER}
      - MONGO_DB_PWD=${MONGO_ADMIN_PASS}

  mongodb:
    image: mongo
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${MONGO_ADMIN_USER}
      - MONGO_INITDB_ROOT_PASSWORD=${MONGO_ADMIN_PASS}

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - "8081:8081"
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=${MONGO_ADMIN_USER}
      - ME_CONFIG_MONGODB_ADMINPASSWORD=${MONGO_ADMIN_PASS}
      - ME_CONFIG_MONGODB_SERVER=mongodb
    depends_on:
      - mongodb
```

---

## Commands to Build/Run This Full Stack

### 0) Ensure variables exist (choose one approach)

**Option A: export variables in terminal**
```bash
export MONGO_ADMIN_USER="admin"
export MONGO_ADMIN_PASS="supersecret"
```

**Option B: create .env file**
```bash
cat > .env << 'EOF'
MONGO_ADMIN_USER=admin
MONGO_ADMIN_PASS=supersecret
EOF
```

### 1) Start the full stack (detached / recommended)
```bash
docker compose -f docker-compose.yaml up -d
```

### 2) Check services status
```bash
docker compose -f docker-compose.yaml ps
```

### 3) Follow logs (all services)
```bash
docker compose -f docker-compose.yaml logs -f
```

### 4) Follow logs for the app only
```bash
docker compose -f docker-compose.yaml logs -f my-app
```

### 5) Rebuild only the app image (when using build:)
Use this when my-app is built locally from a Dockerfile.

```bash
docker compose -f docker-compose.yaml up -d --build
```

### 6) Restart a single service
```bash
docker compose -f docker-compose.yaml restart my-app
docker compose -f docker-compose.yaml restart mongodb
docker compose -f docker-compose.yaml restart mongo-express
```

### 7) Stop without removing containers
```bash
docker compose -f docker-compose.yaml stop
```

### 8) Full cleanup (containers + network)
```bash
docker compose -f docker-compose.yaml down
```

### 9) Full cleanup including volumes (data loss!)
```bash
docker compose -f docker-compose.yaml down -v
```

---

## Choosing Between image and build

### Using a registry image (deployment approach)
```yaml
my-app:
  image: docker-hub-user/image-name:image-tag
```

### Building locally with Dockerfile (development approach)
```yaml
my-app:
  build: .
```

---

## Dockerfile Example for the Node.js Service
This Dockerfile creates a lightweight Node.js container image and runs the application with server.js.

```Dockerfile
# Use a lightweight Node.js base image
FROM node:20-alpine
# Create the application directory inside the container
RUN mkdir -p /home/app
# Copy application source code into the container
COPY ./app /home/app
# Set the working directory for the next instructions
WORKDIR /home/app
# Install dependencies
RUN npm install
# Run the application when the container starts
CMD ["node", "server.js"]
```

---

## Compose Execution Commands (Quick Reference)

```bash
# Start (foreground)
docker compose -f docker-compose.yaml up

# Start (detached)
docker compose -f docker-compose.yaml up -d

# Stop and remove containers + network
docker compose -f docker-compose.yaml down

# Stop only (keep containers)
docker compose -f docker-compose.yaml stop

# Start after stop (reuse same containers)
docker compose -f docker-compose.yaml start

# Show status
docker compose -f docker-compose.yaml ps

# Logs
docker compose -f docker-compose.yaml logs -f
```

Compose uses the folder name by default for resource naming.

To force a consistent project name:
```bash
docker compose -p projects -f docker-compose.yaml up -d
```

---

## Operational Difference: up/down vs start/stop

### up / down
- `up` creates and starts services
- `down` stops and removes containers and networks

### start / stop
- `stop` stops containers without removing them
- `start` restarts the same containers

If you need long-term persistence, configure volumes explicitly.

---

## Startup Ordering With depends_on
If one service must start after another:

```yaml
depends_on:
  - mongodb
```

`depends_on` handles startup order, but it does not guarantee the database is ready to accept connections.  
For readiness, add healthchecks or retry logic.

---

## Scaling and Orchestration Considerations
Compose is great for:
- local development
- small/medium stacks
- demos and labs on a single machine

At large scale (hundreds or thousands of containers across many servers),  
you typically need orchestration features like auto-healing and scaling — that’s where Kubernetes comes in.

# Docker Compose — Core Concepts

## What is Docker Compose?
**Docker Compose** is a tool to run and manage **multi-container applications** using **one declarative YAML file** (usually `compose.yaml`).
Instead of starting containers one-by-one with multiple `docker run` commands (and manually handling networks, ports, volumes, and dependencies), you describe the whole stack once and bring it up with a single command.

---

## Why Compose exists (the real problem it solves)
When an app grows beyond “one container”, you commonly need:
- Database (MySQL/PostgreSQL)
- Cache (Redis)
- Message queue (RabbitMQ)
- API service (FastAPI/Node)
- Frontend / reverse proxy (Nginx)

If you manage these using only `docker run`, you quickly end up with:
- many flags (`-p`, `-e`, `-v`, `--network`, …)
- manual network creation and container linking
- messy teardown and cleanup

Compose turns that into a clean, repeatable setup.

---

## The “one container does one thing” principle
Best practice:
- **One container = one responsibility**
  - API container runs the API only
  - DB container runs the database only
  - Reverse proxy container runs Nginx only  

This makes stacks easier to maintain, debug, scale, and replace.

---

## Key idea: Declarative model
Compose is **declarative**:
- You define the desired state in `compose.yaml`
- Then you run it, and Compose makes reality match your file

Important behavior:
- You don’t need to rebuild everything from scratch every time
- If you edit the file and run Compose again, it **reconciles changes intelligently**

---

## Dockerfile vs Compose file (very important distinction)

### Dockerfile
- Used to **build an image**
- Describes: base image, dependencies, build steps, default command

### Compose file (`compose.yaml`)
- Used to **run containers (services)**
- Describes: services, ports, networks, volumes, environment variables, build context, and runtime configuration

Common real-world pattern:
- Compose file references a Dockerfile to build the image for a service.

---

## What a Compose file typically defines
Inside `compose.yaml`, you usually describe:

### 1) Services
Each **service** becomes a container (or a set of containers if scaled).

Example services:
- `app`
- `db`
- `redis`
- `nginx`

---

### 2) Images / Build
A service can use:
- a ready image: `image: mysql:8`
- or build from source: `build: .`

---

### 3) Ports
Expose container ports to the host.
- Example: `3000:3000` (host:container)

---

### 4) Volumes
Persist data (especially databases) across restarts.
- Example: DB files remain even if container is recreated

---

### 5) Networks
Connect services together privately.
- Compose automatically creates a default network unless you customize it

---

### 6) Environment variables
Configure containers without hardcoding values in code.

---

## Core operational commands you must know

### Start the stack
```bash
docker compose up
```

---

### Start in background (detached)
```bash
docker compose up -d
```

---

### Build images (when using `build:`) and start
```bash
docker compose up -d --build
```

What typically happens during `up`:
- required images are pulled (if not present)
- a network is created for the app
- volumes are created (if defined)
- containers are started with all configuration

---

## Teardown and cleanup

### Stop and remove containers + network (default)
```bash
docker compose down
```

What gets removed:
- containers created by the stack
- the default network created for the stack

---

### Remove volumes too (destructive for DB data)
```bash
docker compose down --volumes
```

Default behavior is safe:
- volumes are NOT removed automatically
- data persists unless explicitly removed

---

## Practical DevOps notes

### 1) “Up again” is the normal workflow
When you change the Compose file or config:
- run `docker compose up` again
- Compose applies only what changed

---

### 2) Data persistence is intentional
- Containers are disposable
- Volumes hold stateful data (DB files)
- This separation is a core container pattern

---

### 3) GUI vs CLI warning
If using Docker Desktop:
- Removing a Compose app from the GUI may remove only containers
- Networks and volumes may remain and require manual cleanup

---

## Minimal mental model
- **Dockerfile** = how to build the image
- **Compose** = how to run the whole system
- **Services** communicate via networks
- **Volumes** persist data
- **`up`** brings desired state online
- **`down`** removes the stack (optionally volumes)

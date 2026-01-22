# Docker Image (Container Image) — Core Concepts

## What is a Docker Image?
A Docker Image is a standardized package that contains everything an application needs to run inside a container.  
It includes:
- Required system files  
- Binaries  
- Libraries  
- Configurations  

The core idea:  
Instead of manually preparing a server, the image carries the entire environment in a ready-to-run form.

### Quick examples
A PostgreSQL image contains:
- Database runtime files  
- Configuration files  
- All required dependencies  

A Python web application image contains:
- Python runtime  
- Application source code  
- Dependencies  

---

## Two very important principles of Docker Images

### 1) Images are Immutable
Once an image is built, it cannot be modified.  
Any change requires:
- Building a new image  
or  
- Adding a new layer on top of an existing image  

Why is this important?
- The same image always produces the same result  
- Prevents environment drift  
- Eliminates “it works on my machine” issues  
- Ensures stability and consistency  

### 2) Images are composed of Layers
A Docker Image is made up of multiple layers.  
Each layer represents filesystem changes such as:
- Adding files  
- Removing files  
- Modifying files  

Why are layers important?
- Enables reuse of existing images  
- Speeds up build and pull operations  
- Docker reuses layers instead of downloading everything again  

---

## How do we build on existing images? (Extending Images)

Practical example:
- Start from a base image such as `python`  
- Add layers:
  - Install dependencies  
  - Add application code  

The result:
- You focus on application logic  
- No need to build the environment from scratch  

---

## Where do we find images? (Finding Images)

### Docker Hub
Docker Hub is the default global marketplace for storing and distributing Docker images.  
You can search for images and run them locally directly.

### Types of trusted content on Docker Hub

#### Docker Official Images
- Curated and officially maintained images  
- Used as the starting point for most projects  
- High quality and secure  

#### Docker Hardened Images
- Minimal images  
- Production-ready  
- Focus on security and reduced attack surface  
- Near-zero CVEs  
- Free and open source  

#### Docker Verified Publishers
- Images published by commercial vendors  
- Verified by Docker  

#### Docker-Sponsored Open Source
- Images from open source projects supported by Docker  

### Common examples
- Redis  
- Memcached  
- Node.js  
- Python  

Used either as ready-to-run services or as base images for applications.

---

## Hands-on practice — searching, pulling, and inspecting layers

### Using Docker Desktop (GUI)
- Open Docker Desktop  
- Navigate to Images  
- Search for an image such as `welcome-to-docker`  
- Perform a pull operation  
- Open image details to inspect:
  - Layers  
  - Installed libraries  
  - Discovered security vulnerabilities  

### Using the CLI

#### Search for an image
```bash
docker search docker/welcome-to-docker
```

Displays available images from Docker Hub

---

####  Pull an image from Docker Hub
```bash
docker pull docker/welcome-to-docker
```

Each line during the pull usually represents a layer

---

#### List locally available images
```bash
docker image ls
```

Displays all images currently available on the system
Note:
The displayed image size represents the uncompressed size,
not the actual download size

---

####  View image layers
```bash
docker image history docker/welcome-to-docker
```

Shows the layers, their sizes, and the commands that created them

---

#### View full commands without truncation
```bash
docker image history --no-trunc docker/welcome-to-docker
```

Useful when commands are long and truncated

---

## Quick summary
- A Docker Image is a ready-to-use runtime environment for applications inside containers  
- Images are immutable after they are built  
- Images are composed of layers  
- Docker Hub is the primary source for images  
- Trusted content provides secure and production-ready images  

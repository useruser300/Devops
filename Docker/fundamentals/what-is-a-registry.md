# Docker Registry — Core Concepts

## What is a Registry?

A **Registry** is a **centralized place** used to store and share **Docker Images**.

A registry can be:
- **Public**, such as **Docker Hub** (the default registry used by Docker).
- **Private**, hosted internally within an organization or on a private server.

Why do we need a registry?
- To **share images** with your team.
- To pull the same image on any machine or server (CI/CD pipelines, Kubernetes clusters, production servers).
- To ensure the same application version runs identically across all environments.

Common Registry Examples:
- Docker Hub (public)
- Amazon ECR
- Azure ACR
- Google GCR / Artifact Registry
- Private solutions such as Harbor, JFrog Artifactory, and GitLab Container Registry

---

## Registry vs Repository

These two terms are often confused, but they are not the same.

### Registry
The **platform or service** that stores and manages container images.

### Repository
A **logical collection** of related images inside a registry.  
A repository usually represents a single project or application.

Practical example:
- Registry: Docker Hub
- Repository: `ali/docker-quickstart`
- Images inside the repository:
  - `ali/docker-quickstart:latest`
  - `ali/docker-quickstart:1.0`
  - `ali/docker-quickstart:2.0`

---

## Image Tags and Versioning

A **Tag** represents a version or label of an image.

If no tag is specified, Docker defaults to `latest`.

In real-world usage (especially in companies and CI/CD pipelines):
- You should **not rely on `latest` in production**.
- Use explicit and meaningful tags such as:
  - `1.0`
  - `2026-01-20`
  - `commit-sha`

Tags are essential for:
- Version control
- Rollbacks
- Stable and predictable deployments

---

## Why Registries Matter in DevOps

Registries enable a clean workflow across environments:
- **Local Development** → Build image
- **CI/CD** → Build, test, and push image
- **Staging / Production** → Pull the exact image version by tag

This reduces “it works on my machine” problems because:
- Everyone deploys the **same built artifact**
- Versions are controlled by **tags**
- Deployments become **repeatable and auditable**

---

## Practical Workflow: Build → Test → Tag → Push

This is the **standard daily workflow** when working with Docker images.

### Build the image
```bash
docker build -t YOUR_DOCKER_USERNAME/docker-quickstart .


---

## Practical Workflow: Build → Test → Tag → Push
This is the **standard daily workflow** when working with Docker images.


### Build the image

```bash
docker build -t YOUR_DOCKER_USERNAME/docker-quickstart .
```

**Important**
*The dot . tells Docker to use the Dockerfile from the current directory.
* Keep the dot `.` at the end — it tells Docker where the build context is and where to find the Dockerfile.

### List local images

```bash
docker images
```
---

## Run the image to test it

```bash
docker run -d -p 8080:8080 YOUR_DOCKER_USERNAME/docker-quickstart
```

What this does:

* `-d` runs the container in the background (detached)
* `-p 8080:8080` maps host port 8080 → container port 8080

Then test it in your browser:

* `http://localhost:8080`

---

## Tagging (Versioning) Before Pushing

Tags are how you version your images.

### Add a version tag

```bash
docker tag YOUR_DOCKER_USERNAME/docker-quickstart YOUR_DOCKER_USERNAME/docker-quickstart:1.0
```

Meaning:

* Same image, new label `:1.0`
* Now you can push/pull a specific, stable version

---

## Push to Docker Hub

```bash
docker push YOUR_DOCKER_USERNAME/docker-quickstart:1.0
```

After pushing:

* Go to your Docker Hub repository
* Open the **Tags** section
* You should see the new tag (e.g., `1.0`)


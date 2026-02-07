# Networking Fundamentals (DevOps Reference)

This document explains the essential networking concepts every software engineer must understand.

The approach follows the growth of a single application over time instead of listing concepts in isolation.  
Each networking concept appears only when a real problem forces its introduction.

The goal is to understand:
- Why each networking concept exists
- What problem it solves
- How the same principles apply across physical servers, cloud, containers, and Kubernetes

The example application used throughout this document is an imaginary e-commerce platform/system called **EcommerceApp**.

**Important Note**

This document focuses on networking concepts from a **system and architecture perspective**, providing a high-level view of how networking requirements evolve as applications grow.

To work confidently with real-world networks, engineers should complement this material with deeper study of networking topics such as:
TCP/IP, OSI layers, routing, switching, subnetting, and protocol behavior.


---

## 1. Single Server — IP Addresses

### Problem
When the application is first launched, it runs entirely on a single server.
The first networking problem appears immediately:

**How do users find the server on the internet?**

### IP Address
An **IP address** is a unique identifier assigned to a device on a network.

Key points:
- Every device on a network must have an IP address
- Other devices use the IP address to know where to send data
- Without an IP address, a server cannot receive network traffic

Public IP addresses:
- A **public IP address** makes a server reachable from the internet
- Any device on the internet can send requests to this address

Analogy:
- IP address = house address for mail delivery

Result:
- The EcommerceApp server becomes reachable by assigning it a public IP address

---

## 2. Human-Friendly Access — DNS

### Problem
IP addresses are numeric and difficult for humans to remember.

### DNS (Domain Name System)
**DNS** translates human-friendly domain names into IP addresses.

How it works:
- Users type a domain name (e.g. `ecommerceapp.com` or `google.com`)
- DNS resolves the name to the correct IP address
- The browser connects to the server using that IP

Key points:
- Humans use names
- Networks use IP addresses
- DNS connects the two

Analogy:
- DNS = phone contact list (name → number)

Result:
- Users can access the server without knowing its IP address

---

## 3. Multiple Applications on a Single Server — Ports

### Problem
The application now runs multiple components on the same server:
- Website
- Database
- Payment service

All components share the same IP address.

**How does the server know which component should receive incoming traffic?**

### Ports
A **port** is a numbered communication endpoint on a server.

Key points:
- Ports range from 1 to 65,535
- Each application listens on a specific port
- Traffic is routed using **IP address + port**

Common ports:
- 80 → HTTP
- 443 → HTTPS
- 3306 → MySQL
- 9090 → Custom payment service

Why ports matter:
- Multiple applications can run on one server safely
- Traffic reaches the correct application

Analogy:
- IP address = building address
- Port = apartment number

Result:
- Traffic is correctly delivered to each application

---

## 4. Security and Segmentation — Subnets, Routing, Firewalls

### Problem
The system now handles sensitive data (credit cards, personal data).

Running everything on one server creates:
- A single point of failure
- High security risk

### Subnets (Network Segmentation)
A **subnet** is a logical division of a network into smaller isolated sections.

Purpose:
- Isolate different system components
- Reduce blast radius of security incidents

Typical layout:
- Public subnet → frontend
- Application subnet → internal services
- Database subnet → sensitive data

### Routing
**Routing** determines how traffic moves between subnets.

Key points:
- Routers decide the path traffic takes
- Enables communication between isolated subnets
- Without routing, subnets are completely isolated and cannot communicate  

Analogy:
- Routing = GPS for network traffic

### Firewalls
Just because traffic **can** move between subnets does not mean it **should**.

A **firewall** is a security mechanism that controls which network traffic is allowed or blocked.

A **firewall** enforces traffic rules.

A **firewall** inspects network traffic and allows or blocks it based on predefined rules.

Firewalls typically follow a default-deny model, where all traffic is blocked unless explicitly allowed.

Firewall rules define:
- Source
- Destination
- Port
- Protocol

Types:
- Host firewall → protects a single server
- Network firewall → filters traffic between subnets

Examples:
- Database allows port 3306 only from application subnet
- Frontend allows inbound 80 and 443 only
- All other traffic is denied by default

Security model:
- Layered security
- Network firewall + host firewall

Result:
- The network is segmented and controlled with clear security boundaries.

---

## 5. NAT — Private Networks and Internet Access

### Problem
The platform now runs ~50 backend servers in a private subnet.

**Private IP addresses:**
- Work only inside internal networks
- Cannot access the internet directly
- Cannot be reached from the internet

But backend servers still need:
- Software updates
- External APIs
- Third-party services

### NAT (Network Address Translation)
**NAT** allows private systems to access the internet securely.

How NAT works:
- Private server sends outbound request to NAT device
- NAT replaces private IP with its public IP
- Response is mapped back to the correct server

Key benefits:
- Servers remain hidden
- One public IP shared by many servers
- Outbound-only internet access

Analogy:
- NAT = office receptionist making external calls

Result:
- Private servers access the internet without exposure

---

## 6. Cloud Networking — VPC, Subnets, Gateways

### Problem
Managing physical servers is slow, expensive, and inflexible.

### Cloud Shift
Moving to the cloud means:
- Renting infrastructure
- Provider manages hardware
- Capacity changes in minutes

**Important:** Networking fundamentals do not change.

### VPC (Virtual Private Cloud)
A **VPC** is an isolated virtual network inside a cloud provider.

Key points:
- Logically isolated from other customers
- Same concepts as on-prem networking

Analogy:
- Renting a private floor in an office building

### Cloud Subnets
Inside a VPC:
- Public subnets → internet-facing systems
- Private subnets → protected systems

### Internet Gateway
- Connects public subnets to the internet
- Acts as the main entrance

### Route Tables
A **route table** is a set of rules that determines where network traffic is sent.

Route tables exist to connect different network segments in a controlled and predictable way.

**Key points:**
- Each subnet has a route table  
- Routes define traffic flow inside the VPC  

### NAT Gateway
- Cloud-managed NAT service
- Enables outbound internet access for private subnets

Result:
The same secure architecture, now cloud-managed and scalable.

---

## 7. Container Networking (Docker)

### Problem
Microservices increase complexity and environment inconsistency.

### Containers
A **container** packages:
- Application code
- Runtime
- Libraries
- Configuration

Benefit:
- Same behavior across all environments

### Docker Bridge Network
- Private network on a single host
- Containers communicate by name

### Port Mapping
Containers have internal ports not accessible externally.

Port mapping:
- Maps host port → container port
- Allows external traffic into containers

Conceptually:
- Similar to NAT (address + port translation)

### Overlay Networks

**Definition**  
An **overlay network** is a virtual network that connects containers running on different servers.

**Purpose**  
It is used when containers are no longer running on one server and must communicate across multiple servers.

**Behavior**  
- Containers on different servers join the same virtual network  
- Containers can talk to each other using internal addresses or names  
- The physical location of the container does not matter  

**Result**  
- Cross-host container communication works automatically  
- Microservices can run on many servers  
- Applications stay portable and consistent  

---

## 8. Kubernetes Networking

### Problem
Managing hundreds of containers manually is impossible.

### Kubernetes
Kubernetes automates:
- Scheduling
- Monitoring
- Restarting
- Scaling

### Pods
A **pod** is the smallest deployable unit in Kubernetes.

Key points:
- Usually one container
- One IP address per pod
- Containers inside a pod share IP and localhost

Pods are **ephemeral**:
- Created and destroyed frequently
- IP addresses change

### Services
Pods are unreliable endpoints.

A **Kubernetes Service**:
- Is created for a set of pods
- Provides a stable IP and DNS name
- Load-balances traffic to healthy pods

Benefits:
- No dependency on pod IPs
- Automatic failover
- Transparent scaling

**Note:**  
By default, Services provide internal cluster access and are not reachable from the internet without components like Ingress.

### Ingress
**Ingress** manages external access to services.

Key points:
- Single entry point into the cluster
- Routes traffic based on hostnames and paths
- Forwards requests to the correct service

Analogy:
- Ingress = reception desk

---

## 9. Recap — Foundational Networking Concepts

### Identification
- IP addresses uniquely identify devices
- DNS maps names to IPs

### Traffic Separation
- Ports direct traffic to the correct application

### Segmentation
- Subnets isolate systems
- Routing connects them

### Security
- Firewalls control allowed traffic
- Default-deny model

### Internet Access
- NAT enables secure outbound access for private systems

### Key Insight
The tools change, but the principles remain the same.

- Physical routers → VPC routing
- Physical firewalls → security groups

By mastering these fundamentals, you can:
- Understand any networked system
- Troubleshoot systematically
- Design secure, scalable architectures at any scale

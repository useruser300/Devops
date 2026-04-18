# Introduction

Terraform is a tool used to manage infrastructure in a structured and repeatable way.
Many people may have heard about it before, or tried it in a simple way, but understanding it more deeply requires looking at it not only as a tool for creating resources, but as a tool that applies important practices such as **Infrastructure as Code**.

The main idea is to understand what Terraform does, how it helps us move from the basic concepts of what infrastructure can do, and how it leads us to think about the complete **infrastructure life cycle management** that Terraform was designed for.

---

# What is Infrastructure as Code?

At the core of understanding Terraform, there is a very important idea called **Infrastructure as Code**.

This concept means moving away from the traditional model where infrastructure is managed manually.

In the traditional model, infrastructure may be managed by:

* logging in to a console
* clicking manually
* logging in to systems
* running commands manually

But in the **Infrastructure as Code** model, infrastructure is handled in a different way.
Infrastructure is **written as code** and treated like a configuration file or like application code.

This means that infrastructure can be:

* written as files
* saved
* placed under **version control**
* stored in a system like Git
* managed in a way that is very similar to how we manage the life cycle of an application

In this way, infrastructure is not just a set of scattered manual settings.
It becomes something clear, reviewable, changeable, and traceable over time.

---

# Infrastructure as Code with Terraform

When using Terraform to apply the concept of **Infrastructure as Code**, everything starts with a **configuration language**.

In Terraform, this language is called:

**HCL — HashiCorp Configuration Language**

This language allows us to define the required resources in a **declarative** way.

Declarative means that the focus is on describing the desired state, meaning what resources should exist, instead of writing every execution step in detail.

When we talk about a **resource** in Terraform, this is a very general concept.

A resource can be almost anything that can be created, modified, or deleted from an infrastructure perspective.

This means that Terraform can manage many different types of resources, such as:

* databases
* virtual machines
* networks
* load balancers
* DNS records
* security settings
* different cloud services

In other words, almost any infrastructure element that can be imagined and can be handled through an interface or an API can often be managed with Terraform.

---

# Example

A simple example of using Terraform is defining a **managed database**.

This database may be accessed by a specific application.
This application may run on a group of **virtual machines**, on **containers**, or it may be a **serverless application**.

These virtual machines may be placed behind a **load balancer**.

In this way, we have a classic example of a **three-tier application**.

This type of application usually consists of:

* a Load Balancer
* that talks to a compute layer
* and the compute layer talks to the database

Instead of creating and managing these components manually, they are defined in Terraform **as code**.

For example, the database settings are defined:

* Is it small?
* Is it medium?
* Is it large?

The VMs are also described:

* What images do they run?
* How should they be configured?

The load balancer is also described:

* and how it should route traffic to the VMs

This approach allows us to use two very important Terraform commands:

* plan
* apply

---

# Plan and Apply

The first command is:

**plan**

In the planning phase, Terraform compares the **desired configuration** with the **current reality**.

The current reality is usually called:

**current state**

Through this comparison, Terraform creates what is called an:

**execution plan**

In other words, Terraform takes:

* the **desired state**
* which is defined through the config
* together with the existing configuration or the current state

From this comparison, Terraform generates a:

**plan**

The plan allows us to inspect what Terraform will do before making any real change.

Through the plan, we can know:

* What will Terraform do?
* Will it create a new resource?
* Will it modify an existing resource?
* Will it delete something that already exists?

This phase is designed so that the operator or the end user has a **high level of confidence** that they understand what Terraform will do before it actually executes it.

After reviewing the plan and making sure that the required change is correct, the second important operation is run, which is:

**apply**

What **apply** does is that it takes the plan, applies it, and then creates a **new state**.

For example, we can move from:

* state 1

to:

* state 2

This means that Terraform does not only execute the change, but it also updates the state it knows about the infrastructure after execution.

---

# Day 0, Day 1, and Day 2

At the beginning, this may seem relatively simple.

You can start from a very basic situation, for example when nothing has been created yet.
In this case, the phase is called:

**day zero**

In **day zero**, no infrastructure is running.

At this point, the initial plan is very easy, because the current reality does not contain any resources, while the desired state contains all the resources that should be created.

In this case, the desired state is very simple:

* create everything

So, in the initial plan, Terraform will show that:

* nothing is currently running
* the database will be created
* the VMs will be created
* the load balancers will be created

When the operation is run, Terraform starts creating these things.
After that, there is an **initial state**.

This means that the first set of resources has been created and is now managed.

But when we move into **day two**, the need for modification and development begins.

For example, there may be a need to:

* add a **DNS record** in front
* **resize** the database from **small** to **medium**
* add more compute capacity by creating a new **virtual machine**

This represents the classic evolution of infrastructure.

It is very rare to create infrastructure once and then never change it again.
Most of the time, infrastructure is developed and changed over time.

With Terraform, these changes are not made manually.
Instead, the configuration files are updated.

For example:

* instead of a small database, a medium database is requested
* instead of three VMs, four VMs are requested

After making these changes in the configuration, **Terraform plan** is run again.

At this point, Terraform analyzes the situation and shows that there are new differences.

For example, the plan may show that:

* the DNS record did not exist before, so it must be created
* the three existing VMs are still there
* the fourth VM is new, so it must be created
* the load balancer has a dependency, because it needs to know the VMs that it will balance traffic across

After creating the fourth VM, the existing load balancer must be modified so that it knows about this new VM.

The same applies to the database.

The database was previously **small**, and now it is requested as **medium**, so this setting must also be modified.

Here we can see that a relatively simple set of changes can make the plan more complex.

This is because the issue is not only about creating or modifying separate resources, but there are also:

* execution order
* dependencies between resources
* relationships between components

For example:

The new VM must be created first before modifying the load balancer, because the load balancer needs to know information about this VM, such as its IP address.

The DNS may also need to wait until the load balancer is updated, so that it knows which load balancer it should point to.

In this way, the plan can provide more detailed information.

It shows:

* What will be created?
* What will be modified?
* What will be deleted?
* What is the execution order of these things?
* What are the dependencies between them?

When **apply** is run, Terraform executes these steps in the correct order.

If any error happens, Terraform stops at the appropriate stage.

---

# Infrastructure Life Cycle

When looking at Terraform in this way, it becomes clear that the discussion is not only about creating resources.
It directly enters the concept of:

**infrastructure life cycle**

In **day one**, the initial creation happens.
After that, the phase of modification and development begins.
This is where the discussion about **day two** starts.

Infrastructure is rarely something that is created once and then finished.
It is better to think about it as a set of stages or life cycles.

We can think about **day zero** as the phase of **setting the foundation**.

In this phase, the environment may be completely empty.

There may not even be a ready cloud account yet, such as:

* an Amazon account
* a GCP account
* an Azure account

So this phase starts with a question like:

How can the initial account be created in GCP, Amazon, or Azure?
And how can the basic **landing zone** be prepared?

The landing zone can include:

* the basic virtual networks
* the initial settings
* a set of **guardrails**
* rules and controls that govern the environment from the beginning

Therefore, **day zero** is often the phase of setting up the landing zone.

After the foundation is prepared, we reach **day one**.

In **day one**, the question is:

* How is the initial deployment of infrastructure and applications done?

In the previous example, **day one** may be the phase where the following are started:

* the load balancer
* the three VMs
* the core database

This is the initial part of infrastructure deployment.

After that, infrastructure usually lives for a very long time, often as long as the applications themselves live.

Here we reach:

**day two, day three and beyond**

This can continue until:

**day n**

In **day two**, changes may be made, such as:

* adding DNS
* adding a new virtual machine
* increasing the size of the database

These changes may continue throughout the life of the application.

The infrastructure continues to be developed and modified.

The image running on the virtual machine may need a patch, because it is running an old version of Linux and must be updated because of a known vulnerability.

In this way, there is continuous care throughout the life cycle of the image.

The application may also become very popular, which requires:

* scaling up
* adding more resources
* adding more complexity to the infrastructure

In the end, the application may reach:

**end of life**

At that point, the application is no longer needed, and it can be:

**decommissioned**

But before reaching that stage, we must deal with:

* day two
* day three
* day four
* and so on

All these continuous stages are often shortened to the term:

**day two plus**

Inside the **day two plus** phase, there are many types of work, such as:

* patch management
* vulnerability management
* right sizing from the load perspective and from the cost perspective
* making changes to new versions
* deploying new infrastructure
* changing the architecture
* moving from VMs to containers
* adding a message queue
* adding a Redis cache

Each one of these things requires evolution and change in the infrastructure.

If the environment is larger, other considerations also appear, such as:

* compliance
* audit

Requirements may change if the environment is, for example, committed to **PCI compliance**, and then the PCI specification or compliance controls change.

The company may also suddenly decide that it wants to become **HIPAA certified**, and this leads to new changes in the requirements.

Therefore, there is a large amount of complexity inside the:

**day 2 / day 3**

environment.

When thinking about cost, questions appear such as:

* How can we know which applications spend the most in the cloud?
* Which teams should be notified if they go over budget?
* How can we optimize spending if there are many idle resources?

All of these things become part of the picture when thinking about the infrastructure life cycle.

---

# What Infrastructure as Code Gives Us

One of the main advantages of Terraform is that moving to code allows us to automate the way we think about every part of this life cycle.

At the beginning, the shape of the landing zone can be defined in code, and then it can be provisioned automatically during the initial deployment.

After that, the same approach can be used when dealing with things like:

**patching**

For example, the image being used can be changed.

The environment may be running:

**version one**

Then it can be changed to:

**version two**

In this way, Terraform can be used to automate:

* re-patching
* changing all machine images in the environment

When thinking about **right sizing**, the example of moving from **small** to **medium** appears.

If the load increases, a larger database may be needed.

But the opposite can also be true.

The database may be larger than needed, and for cost-related reasons, it can be made smaller to optimize cloud spending.

So, the core of **Infrastructure as Code** is that it enables all of these things to be done in a clear and understandable way.

We can always look at the code to understand:

* the current state of the infrastructure
* the desired state of the infrastructure

We can also put:

* automation
* guardrails

around all of these areas.

---

# Policy as Code

One of the main concepts related to this approach is:

**Policy as Code**

The idea here is that while changes are being made, we must make sure that they are done in a safe and correct way.

Policies can be written as code.

There may be a policy that looks at:

* cost
* security
* compliance
* operational best practices

The important point is that while moving through this life cycle, these policies can be applied in a **programmatic** way.

The process starts from the **plan**.

At this stage, it is known what Terraform will create, modify, or delete.

Before reaching **apply**, meaning before making actual changes in the cloud environments, these policies can be taken and enforced in the middle stage.

The plan can be inspected.

For example:

* If the plan is about to create a new **firewall rule** that allows the whole internet to access something, this can be considered not allowed because it violates a security policy.
* If the plan modifies the database to turn off **encryption**, this can be considered not allowed because it violates a compliance check.
* If the plan deletes the VMs and leaves only one VM behind the load balancer, this can be blocked because from an **operational reliability** perspective, it creates a **single point of failure**.

Each one of these cases can be a **policy** applied during the:

**plan / apply**

cycle.

Using these policies, it is possible to enforce whether changes should be allowed or not.

---

# Modules

When thinking about the different applications that are deployed, there are often common patterns between them.

Not every application is completely unique.

There may be many applications of the type:

**Java applications**

There may also be many applications that use a common type of database, such as:

* Postgres
* MySQL

Therefore, it does not make sense to reinvent the wheel every time, or to define the same things again and again.

Here, another important strength of **Infrastructure as Code** appears, which is:

* reusability
* modularity

In Terraform, you may start first by defining many things as:

**individual resources**

or as a one-time special pattern.

But over time, repeated patterns will appear.

When these patterns repeat, something called a:

**module**

is often created.

For example, the module may be for a:

**Java application**

This module can contain several **inputs**.

For example, it can define:

* How many instances should run?
* What is the jar file?
* In which regions should the application be deployed?

The output of this module may be, for example:

* the DNS address of the load balancer

In this way, the complexity is wrapped inside the module.

The pattern may be, for example:

* a Java app
* that has a DNS record
* in front of it a load balancer
* and inside it a group of virtual machines or containers

But the user does not need to deal with all of these details directly.

The user only consumes the module by providing the inputs and getting the outputs.

---

# Terraform Registry

After creating these modules, they can be published as part of a wider **registry**.

When thinking about the **Terraform Registry**, it is a way to create reuse for common patterns.

There may be:

* a Java pattern
* a C# pattern
* a pattern for databases
* a module for SQL
* a module for Redis

All of these start to become **reusable libraries**.

Therefore, when different teams deploy applications to the cloud, they do not reinvent the way to manage:

* Java
* MySQL
* Redis

Instead, they can pull these components, provide the inputs, and then compose larger and more complex infrastructures.

---

# Module Life Cycle Management

Each one of these modules can also have its own **life cycle**.

For example, there may be:

* the first version
* then a vulnerability appears
* then there is a new version
* then there is a need to upgrade the runtime

At that point, a **new version** can be published.

This enters what is called:

**module life cycle management**

In a large organization, there may be hundreds of applications running as Java apps inside the environment.

If a **new version of the JDK** appears, there is a need to handle the upgrade of hundreds of applications in a consistent way.

By having a shared set of **versioned** modules, life cycle management can be applied.

For example, it is possible to:

* publish a new version
* gradually deprecate the old version
* notify teams that they need to upgrade
* enable a somewhat automated upgrade path

---

# Terraform Community and HCP Terraform

Across these stages, it is often possible to start in **day zero** and **day one** using:

**Terraform Community Edition**

But when moving to **day 2 / day 3** enterprise challenges, there may be a need to use something like:

**Terraform Cloud**

or:

**HCP Terraform**

The reason is that this stage needs practices that make management easier at a larger scale.

For example, it is possible to use:

* **module registry**
* sharing modules between teams

It is also possible to write a **policy** and apply it as part of the:

**plan / apply**

cycle.

It is also possible to apply:

**role-based access control**

so that it can be defined:

* which users have access
* and what things they are allowed to change

Then it becomes possible to start integrating with different systems to solve different problems.

---

# Terraform Integrations

When talking about things like:

* patching
* vulnerability management

an important integration point appears with tools such as:

* **Ansible**
* **configuration management** tools

When thinking about things like:

* right sizing
* cost reporting
* cost optimization
* chargebacks for different teams

there is an opportunity to integrate with different **FinOps** tools.

These tools help with:

* creating cost reports
* optimizing cost
* doing chargebacks to different teams

Examples of these tools are:

* **Apptio**
* **Turbonomic**
* **Cloudability**

Each one of these tools solves a different type of problem.

These tools can be combined together using the APIs of systems such as:

**Terraform Cloud**

From the perspective of:

* security
* policies

Terraform can integrate with tools such as:

* **Wiz**
* **Palo Alto** solutions

It is also possible to apply **policy as code** natively inside Terraform Cloud using:

* **Open Policy Agent**
* **Sentinel engine**

Terraform Cloud supports:

* Open Policy Agent
* Sentinel policies

This allows different workflows to be introduced.

From the perspective of:

* compliance
* audit

these areas can be solved by having clear visibility into:

* who made which Terraform changes
* and when these changes were made

This is a core value of having management centralized inside a system such as:

**Terraform Cloud**

Because this allows knowing:

* all the different Terraform workspaces
* what changes they made
* every Terraform plan
* every Terraform state file
* what changed between them

This gives:

* better visibility
* better control

As a result, doing **audit** becomes possible in a reasonable way, because all changes are managed centrally.

All of this becomes part of the bigger picture:

How can an **Infrastructure as Code workflow** be taken and scaled from something that works for a small team of one or two people, into something that works at the level of a large organization with:

* hundreds of developers
* hundreds of different teams

---

# Image Management with Packer

When thinking about the complete life cycle, there are many other problems.

The topic is not only limited to what **Infrastructure as Code** can do with the resources themselves.

There are also challenges related to:

**image life cycle management**

Here, tools like:

**Packer**

come in.

Packer applies a similar philosophy to Infrastructure as Code, but in the context of building images.

Code is defined and given to Packer so that it can build:

**machine images**

These images may be:

* a VM image such as an Amazon AMI
* an Azure image
* a GCP image

They can also be:

* a container image such as Docker

The goal is very similar.

In **day zero** and **day one**, there may be a need to **bake** a VM image or a container image.

But in **day two**, there may be a need to update this image to:

* a new version of Linux
* a new version of the application
* a new version of the Java runtime

Here, the question becomes:

How is this new version built and then published?

This connects to tools such as:

**HCP Packer**

Using HCP Packer, a **versioned image** can be created and then published at the level of a large organization.

Similar to the idea of a private registry, there may be:

* a secure base operating system
* with the first version
* then it is updated to the second version
* then it is published to hundreds of different teams that pull this image and use it to deploy their infrastructure

Across this life cycle, it is necessary to deal with:

* the initial building of images
* updating images
* patching images during their life cycle
* deleting images when they are no longer used

---

# Developer Self-Service with Waypoint

When moving to higher layers, an important topic appears, which is:

**internal developer portals**

When thinking about the goal of most developers, they usually do not care about the details of how infrastructure is managed.

Developers want to focus on:

* the application
* source code
* a small amount of metadata about the application

So an important question appears:

How can this approach be integrated with infrastructure?

Here comes the role of:

**Waypoint**

Waypoint works almost as a **translation layer**.

Its function is to separate:

* what matters to the developer
* from what matters to operations teams or platform teams

Platform teams usually care about how to define the patterns through which applications are deployed.

This brings us back to things such as:

* Java pattern
* C# pattern
* MySQL pattern

In this way, the developer can stay at the logical application level and say:

* I want to build a Java app that needs a database

This is the level of metadata that the developer cares about.

This information can be provided as input to **Waypoint**.

After that, Waypoint can integrate closely with **Terraform modules** so that it can actually provision these resources.

These patterns are called:

**golden patterns**

They are based on:

* repeatable modules
* Infrastructure as Code

In this way, whether there is:

* one application
* 10 applications
* or 50 applications

these applications can be built on Infrastructure as Code, managed in a versioned way, upgraded, and have version upgrades applied to them, without the need to expose all the complexity to a user who may not want to care about Infrastructure as Code or the details of infrastructure in the first place.

To make these patterns work, they are connected to a set of:

**actions**

For example, there may be:

* a Java pattern

This pattern needs a:

* build action

so that it is possible to:

* build a new version
* deploy it
* run a rollback if something goes wrong

Each basic workflow has an **action** connected to it.

These actions may run different commands.

For example:

* **build** may run a **CI/CD pipeline**
* **deploy** may need to use **Helm** to interact with Kubernetes
* **rollback** may have its own set of instructions

The goal is to enable **platform operations** teams to define:

* all their patterns
* all their workflows

in a **codified** way.

In this way, these patterns and workflows become:

* repeatable
* governable
* able to run in an automated way

Then they are exposed to developers in a simple way that allows them to consume them through:

**self-service**

without needing to learn and manage all of this complexity.

In the end, the goal is to enable development teams to deliver their applications across this whole landscape in an automated way.

The foundation that makes this possible is:

**Infrastructure as Code**

This is the direction that the industry has moved toward.

---

# Terraform Providers

The power of Terraform is that it allows this approach to be applied in a consistent way across:

* the whole life cycle
* all the different environments

What makes Terraform very flexible is that it has a:

**provider ecosystem**

There are **Terraform providers** for well-known cloud providers, such as:

* Amazon
* Google
* Azure
* Oracle
* and others

But it does not stop at the cloud only.

Terraform also extends to:

* on-prem resources such as VMware and OpenStack
* hardware devices such as Cisco networking gear
* platforms such as Kubernetes
* SaaS services such as Datadog or PagerDuty

All of these things can be managed **as code**.

When delivering an application, the topic is not only about the core infrastructure.
It also includes everything around that application.

For example, it is possible to configure:

* the DataDog dashboard that alerts on it
* its Kubernetes application
* the Cisco router that may be the foundation of the network supporting that application

Here, the real power of applying **Infrastructure as Code** appears.

It becomes possible to do:

**full stack delivery**

in an automated way across the whole life cycle.

---

# Conclusion

Terraform contains many concepts and details that can be studied more deeply.

Learning can continue through:

* reading the documentation
* studying more materials about Terraform
* starting to use Terraform in practice

The main idea to take away is that Terraform is not only a tool for creating resources.
It is a way to manage infrastructure as code across its complete life cycle, in a way that is repeatable, reviewable, automatable, and scalable inside teams and organizations.
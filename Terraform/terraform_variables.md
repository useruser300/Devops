# Terraform Variables

## Introduction
Terraform variables are used to make infrastructure code flexible, reusable, and easier to maintain. Instead of hardcoding values directly in resources, you define inputs and provide different values when needed.

This allows you to use the same infrastructure code across multiple environments such as development, testing, and production.

---

## Why Use Variables?

### Cleaner Code
Keep resource logic inside `main.tf` and values inside separate files.

### Reusability
Use the same Terraform code with different settings.

### Easier Environment Management
Deploy multiple environments without rewriting resources.

---

## variables.tf
The `variables.tf` file is commonly used to define input variables.

```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "172.16.1.0/24"
}

variable "az" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}
```

---

## Using Variables in main.tf

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.az
}
```

Terraform reads values using the `var.<name>` syntax.

---

## Default Values
If no custom value is provided, Terraform uses the `default` value defined in `variables.tf`.

---

## terraform.tfvars
The `terraform.tfvars` file is used to override default values.

```hcl
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
az                 = "us-east-1b"
```

When this file exists, Terraform uses these values instead of the defaults.

---

## Multiple Environments
You can create separate variable files for each environment.

### Development
`dev.tfvars`

```hcl
vpc_cidr    = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"
```

Run:

```bash
terraform apply -var-file="dev.tfvars"
```

### Production
`prod.tfvars`

```hcl
vpc_cidr    = "172.16.0.0/16"
subnet_cidr = "172.16.1.0/24"
```

Run:

```bash
terraform apply -var-file="prod.tfvars"
```

---

## Useful Commands

```bash
terraform plan
terraform apply
```

Use `terraform plan` first to review changes before deployment.

---

## Variable Value Priority
Terraform uses the following priority order:

1. `-var` and `-var-file`
2. `*.auto.tfvars`
3. `terraform.tfvars`
4. Environment variables
5. `default` values

---

## Common Data Types
- `string`
- `number`
- `bool`
- `list(...)`
- `map(...)`
- `object(...)`

---

## Variable Block Arguments

## Complete Example

The following example demonstrates the most common arguments used inside a Terraform `variable` block. It includes different data types and practical use cases such as validation, sensitive values, nullable inputs, and temporary runtime values.

```hcl
variable "instance_type" {
  # string type variable with a default value

  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "server_count" {
  # number type variable
  type        = number
  default     = 2
  description = "Number of EC2 instances"
}

variable "enable_monitoring" {
  # boolean variable to enable or disable monitoring
  type        = bool
  default     = true
  description = "Enable detailed monitoring"
}

variable "subnet_ids" {
  # list of subnet IDs
  type        = list(string)
  description = "List of subnet IDs"
  default     = ["subnet-12345", "subnet-67890"]
}

variable "server_config" {
  # object variable with structured settings
  type = object({
    cpu    = number
    memory = number
  })

  default = {
    cpu    = 2
    memory = 4
  }

  description = "Server configuration object"
}

variable "environment" {
  # validation ensures only allowed values are accepted
  type        = string
  default     = "dev"
  description = "Deployment environment"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Must be dev or prod"
  }
}

variable "database_password" {
  # sensitive hides the value from Terraform output
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "instance_name" {
  # nullable = false means null is not allowed
  type        = string
  description = "EC2 instance name"
  nullable    = false
}

variable "session_token" {
  # ephemeral value is available only during runtime and not stored in state
  type        = string
  description = "Temporary AWS session token"
  ephemeral   = true
}
```

---

### type
Defines the allowed data type.

Examples:
- `string`
- `number`
- `bool`
- `list(string)`
- `object({...})`

### default
Sets a fallback value. If no value is provided, Terraform uses the default.

### description
Explains the purpose of the variable.

### validation
Adds custom rules for accepted values.

```hcl
validation {
  condition     = contains(["dev", "prod"], var.environment)
  error_message = "Must be dev or prod"
}
```

### sensitive
Hides secret values from CLI output.
Useful for passwords and API keys.

### nullable
Controls whether the variable can be `null`.

### ephemeral
Temporary runtime-only values that are not stored in state.
Useful for session tokens.

---

## How to Pass Variable Values

### CLI
```bash
terraform apply -var="instance_type=t3.medium"
```

### tfvars Files
Examples:
- `terraform.tfvars`
- `production.auto.tfvars`

### Environment Variables
```bash
export TF_VAR_instance_type=t3.medium
```

---

## Undeclared Variables
- `-var` => Error
- In tfvars file => Warning
- Environment variable => Ignored

---

## Larger Practical Example

The same architecture may include:

- VPC
- Public Subnet
- Private Subnet
- NAT Gateway
- EC2
- Security Groups

But each environment can use different settings.

| Environment | Servers | Instance Type | Network Size |
| ----------- | ------- | ------------- | ------------ |
| Dev         | 1       | t3.micro      | Small        |
| Test        | 2       | t3.small      | Medium       |
| Prod        | 4       | t3.medium     | Large        |

This shows how Terraform variables allow you to reuse the same infrastructure design while changing only the values for each environment.

---

## Summary
Terraform variables help you:

- Write cleaner code
- Reuse the same infrastructure
- Separate logic from values
- Manage multiple environments easily
- Override settings without editing resources directly

Variables are one of the most important Terraform concepts for building scalable and professional Infrastructure as Code projects.


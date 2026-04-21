variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "az" {
  description = "Availability zone for the subnets"
  type        = string
  
}

variable "vm_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}
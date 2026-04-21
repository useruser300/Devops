

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "vm_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}
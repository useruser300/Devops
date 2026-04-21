variable "vpc_id" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "vm_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}
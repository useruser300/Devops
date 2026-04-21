variable "aws-region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "vpc name"
  type        = string
}
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "az" {
  description = "Availability zone for the subnets"
  type        = string
  
}

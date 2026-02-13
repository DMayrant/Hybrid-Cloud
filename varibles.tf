variable "private_subnet_count" {
  type    = number
  default = 6

}

variable "public_subnet_count" {
  type    = number
  default = 3

}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.129.0.0/24",
    "10.129.1.0/24",
    "10.129.2.0/24",
    "10.129.3.0/24",
    "10.129.4.0/24",
    "10.129.5.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.129.100.0/24",
    "10.129.105.0/24",
    "10.129.110.0/24",
    "10.129.115.0/24",
    "10.129.120.0/24",
    "10.129.125.0/24"
  ]
}

variable "aurora_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.129.200.0/24",
    "10.129.210.0/24",
    "10.129.220.0/24",
    "10.129.230.0/24",
    "10.129.240.0/24",
    "10.129.250.0/24"
  ]
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
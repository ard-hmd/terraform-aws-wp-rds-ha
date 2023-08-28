# Set the default AWS region for the resources
variable "aws_region" {
  default = "eu-west-3"
}

# Local variable to generate availability zones based on the AWS region
locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

# Set the default environment
variable "environment" {
  default = "prod"
}

# Set the CIDR block for the VPC
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the VPC"
}

# Define the CIDR blocks for public subnets
variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.0.0/20", "10.0.128.0/20"]
  description = "CIDR blocks for Public Subnets"
}

# Define the CIDR blocks for private subnets
variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.16.0/20", "10.0.144.0/20"]
  description = "CIDR blocks for Private Subnets"
}

# Define the database username variable
variable "db_username" {
  description = "The database username"
  type        = string
}

# Define the sensitive database password variable
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

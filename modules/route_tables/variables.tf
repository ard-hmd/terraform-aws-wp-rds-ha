# Define the ID of the VPC
variable "vpc_id" {
  description = "ID of the VPC"  # Describing the purpose of the variable
}

# Define a list of CIDR blocks for private subnets
variable "private_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"  # Describing the purpose of the variable
}

# Define a list of CIDR blocks for public subnets
variable "public_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"  # Describing the purpose of the variable
}

# Define a list of availability zones
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"  # Describing the purpose of the variable
}

# Define a list of public subnet IDs
variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"  # Describing the purpose of the variable
}

# Define a list of private subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"  # Describing the purpose of the variable
}

# Define the environment
variable "environment" {
  type        = string
  description = "Environment"  # Describing the purpose of the variable
}

# Define the ID of the Internet Gateway
variable "internet_gateway_id" {
  type        = string
  description = "ID of the Internet Gateway"  # Describing the purpose of the variable
}

# Define a list of NAT Gateway IDs
variable "nat_gateway_ids" {
  type        = list(string)
  description = "List of NAT Gateway IDs"  # Describing the purpose of the variable
}

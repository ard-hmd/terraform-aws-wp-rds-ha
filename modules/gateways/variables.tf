# Define the ID of the VPC
variable "vpc_id" {
  description = "ID of the VPC"  # Describe the purpose of the variable
}

# Define a list of CIDR blocks for public subnets
variable "public_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"  # Describe the purpose of the variable
}

# Define a list of availability zones
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"  # Describe the purpose of the variable
}

# Define a list of public subnet IDs
variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"  # Describe the purpose of the variable
}

# Define the environment name
variable "environment" {
  type        = string
  description = "Environment"  # Describe the purpose of the variable
}

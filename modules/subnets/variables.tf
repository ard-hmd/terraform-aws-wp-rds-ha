# Variable: VPC ID
variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
}

# Variable: Public Subnet CIDR Blocks
variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets."
}

# Variable: Private Subnet CIDR Blocks
variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets."
}

# Variable: Availability Zones
variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
}

# Variable: Environment
variable "environment" {
  description = "The environment for which resources are being created."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "internet_gateway_id" {
  type        = string
  description = "ID of the Internet Gateway"
}

variable "nat_gateway_ids" {
  type        = list(string)
  description = "List of NAT Gateway IDs"
}

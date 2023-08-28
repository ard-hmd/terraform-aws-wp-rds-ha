# Define the name for the Load Balancer
variable "lb_name" {
  description = "Name for the Load Balancer"  # Describing the purpose of the variable
  type        = string
}

# Define the Security Group ID for the Load Balancer
variable "security_group_id" {
  description = "Security Group ID for the Load Balancer"  # Describing the purpose of the variable
  type        = string
}

# Define a list of IDs for public subnets
variable "public_subnets_ids" {
  description = "List of IDs for public subnets"  # Describing the purpose of the variable
  type        = list(string)
}

# Define the name for the Target Group
variable "target_group_name" {
  description = "Name for the Target Group"  # Describing the purpose of the variable
  type        = string
}

# Define the ID of the VPC
variable "vpc_id" {
  description = "ID of the VPC"  # Describing the purpose of the variable
  type        = string
}

# Define the ID of the Auto Scaling Group to attach to the Load Balancer
variable "asg_id" {
  description = "ID of the Auto Scaling Group to attach to the Load Balancer"  # Describing the purpose of the variable
  type        = string
}

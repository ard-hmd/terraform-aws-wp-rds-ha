variable "lb_name" {
  description = "Name for the Load Balancer"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the Load Balancer"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of IDs for public subnets"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name for the Target Group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "asg_id" {
  description = "ID of the Auto Scaling Group to attach to the Load Balancer"
  type        = string
}

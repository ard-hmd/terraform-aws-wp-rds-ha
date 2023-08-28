variable "ami_id" {
  description = "The AMI ID to use for the instances"
  default     = "ami-0041b98fa770e38cd"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t2.micro"
  type        = string
}

variable "key_name" {
  description = "The key pair name"
  default     = "kp-ahermand"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instances"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group Name"
  default     = "bastion"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the auto scaling group"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the auto scaling group"
  default     = 2
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the auto scaling group"
  default     = 1
  type        = number
}

variable "vpc_zone_identifier" {
  description = "List of VPC Subnet IDs for the auto scaling group"
  type        = list(string)
}

variable "health_check_type" {
  description = "Type of health check"
  default     = "ELB"
  type        = string
}

variable "asg_tag_name" {
  description = "Name tag for the Auto Scaling Group"
  default     = "HashiCorp Learn ASG - Bastion"
  type        = string
}


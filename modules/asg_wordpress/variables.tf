variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
  default     = "ami-0041b98fa770e38cd"
}

variable "user_data_template" {
  description = "Path to the user data template"
  type        = string
  default     = "user-data.sh.tpl"
}

variable "wp_host" {
  description = "The WordPress host endpoint"
  type        = string
}

variable "wp_user" {
  description = "The WordPress user"
  type        = string
}

variable "wp_pass" {
  description = "The WordPress password"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instances"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the auto scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the auto scaling group"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances in the auto scaling group"
  type        = number
  default     = 2
}

variable "vpc_zone_identifier" {
  description = "List of VPC Subnet IDs for the auto scaling group"
  type        = list(string)
}

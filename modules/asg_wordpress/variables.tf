# Define variables for the configuration

variable "ami_id" {
  description = "The AMI ID to use for the instances"  # Describe the purpose of the variable
  type        = string
  default     = "ami-0041b98fa770e38cd"  # Default AMI ID for instances
}

variable "user_data_template" {
  description = "Path to the user data template"  # Describe the purpose of the variable
  type        = string
  default     = "user-data.sh.tpl"  # Default template file for user data
}

variable "wp_host" {
  description = "The WordPress host endpoint"  # Describe the purpose of the variable
  type        = string
}

variable "wp_user" {
  description = "The WordPress user"  # Describe the purpose of the variable
  type        = string
}

variable "wp_pass" {
  description = "The WordPress password"  # Describe the purpose of the variable
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"  # Describe the purpose of the variable
  type        = string
  default     = "t2.micro"  # Default instance type
}

variable "key_name" {
  description = "The key pair name"  # Describe the purpose of the variable
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instances"  # Describe the purpose of the variable
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in the auto scaling group"  # Describe the purpose of the variable
  type        = number
  default     = 1  # Default minimum number of instances
}

variable "max_size" {
  description = "Maximum number of instances in the auto scaling group"  # Describe the purpose of the variable
  type        = number
  default     = 2  # Default maximum number of instances
}

variable "desired_capacity" {
  description = "Desired number of instances in the auto scaling group"  # Describe the purpose of the variable
  type        = number
  default     = 2  # Default desired number of instances
}

variable "vpc_zone_identifier" {
  description = "List of VPC Subnet IDs for the auto scaling group"  # Describe the purpose of the variable
  type        = list(string)
}

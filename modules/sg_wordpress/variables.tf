# Define the ID of the VPC where the security group will be created
variable "vpc_id" {
  description = "The VPC ID where the security group will be created"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

# Define the security group ID of the Load Balancer for WordPress
variable "wordpress_lb_sg_id" {
  description = "Security group ID of the Load Balancer for WordPress"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

# Define the security group ID of the Bastion instance
variable "bastion_instance_sg_id" {
  description = "Security group ID of the Bastion instance"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

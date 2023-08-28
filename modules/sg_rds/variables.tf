# Define the security group ID for the WordPress instance
variable "wordpress_instance_sg_id" {
  description = "The security group ID for the WordPress instance"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

# Define the ID of the VPC where the RDS security group will be created
variable "vpc_id" {
  description = "The VPC ID where the RDS security group will be created"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

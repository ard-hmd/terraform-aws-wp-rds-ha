# Define the ID of the VPC where the security group will be created
variable "vpc_id" {
  description = "The VPC ID where the security group will be created"  # Describing the purpose of the variable
  type        = string  # Specifying the data type of the variable
}

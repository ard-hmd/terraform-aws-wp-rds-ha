variable "wordpress_instance_sg_id" {
  description = "The security group ID for the WordPress instance"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the RDS security group will be created"
  type        = string
}

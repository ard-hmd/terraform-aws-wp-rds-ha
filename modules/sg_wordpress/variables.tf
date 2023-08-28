variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "wordpress_lb_sg_id" {
  description = "Security group ID of the Load Balancer for WordPress"
  type        = string
}

variable "bastion_instance_sg_id" {
  description = "Security group ID of the Bastion instance"
  type        = string
}

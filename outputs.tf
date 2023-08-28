# Outputs related to networking and infrastructure components

# VPC ID
output "vpc_id" {
    value = module.vpc.vpc_id
}

# IDs of public subnets
output "public_subnet_ids" {
    value = var.public_subnets_cidr
}

# IDs of private subnets
output "private_subnet_ids" {
    value = var.public_subnets_cidr
}

# IDs of NAT Gateways
output "nat_gateway_ids" {
  value = module.gateways.nat_gateway_ids
}

# IDs of AWS Internet Gateways
output "aws_internet_gateway_ids" {
  value = module.gateways.aws_internet_gateway_ids
}

# IDs of private route tables
output "private_route_table_ids" {
  value = module.route_tables.private_route_table_ids
}

# ID of the public route table
output "public_route_table_id" {
  value = module.route_tables.public_route_table_id
}

# Outputs related to Auto Scaling Groups and Launch Configurations

# Name of the launch configuration used by the WordPress ASG module
output "auto_scaling_group_launch_configuration_name" {
  description = "The name of the launch configuration from the auto scaling module"
  value       = module.asg_wordpress.launch_configuration_name
}

# Name of the auto scaling group created by the WordPress ASG module
output "auto_scaling_group_name" {
  description = "The name of the auto scaling group from the auto scaling module"
  value       = module.asg_wordpress.autoscaling_group_name
}

# Name of the launch configuration used by the Bastion ASG module
output "launch_configuration_name" {
  description = "The name of the launch configuration from the bastion ASG module."
  value       = module.asg_bastion.launch_configuration_name
}

# Name of the auto scaling group created by the Bastion ASG module
output "autoscaling_group_name" {
  description = "The name of the auto scaling group from the bastion ASG module."
  value       = module.asg_bastion.autoscaling_group_name
}

# Outputs related to Load Balancers

# ARN of the Load Balancer
output "lb_arn" {
  description = "ARN of the Load Balancer"
  value       = module.lb_wordpress.lb_arn
}

# DNS name of the Load Balancer
output "lb_dns_name" {
  description = "ARN of the Load Balancer"
  value       = module.lb_wordpress.lb_dns_name
}

# ARN of the Load Balancer Listener
output "lb_listener_arn" {
  description = "ARN of the Load Balancer Listener"
  value       = module.lb_wordpress.lb_listener_arn
}

# ARN of the Load Balancer Target Group
output "lb_target_group_arn" {
  description = "ARN of the Load Balancer Target Group"
  value       = module.lb_wordpress.lb_target_group_arn
}

# Outputs related to Security Groups

# ID of the WordPress instance security group
output "sg_wordpress_id" {
  description = "The ID of the WordPress instance security group"
  value       = module.sg_wordpress.sg_wordpress_id
}

# ID of the bastion instance security group
output "sg_bastion_id" {
  description = "The ID of the bastion instance security group"
  value       = module.sg_bastion.sg_bastion_id
}

# ID of the WordPress load balancer security group
output "sg_lb_wordpress_id" {
  description = "The ID of the WordPress load balancer security group"
  value       = module.sg_lb_wordpress.sg_lb_wordpress_id
}

# ID of the RDS security group
output "sg_rds_id" {
  description = "The ID of the RDS security group"
  value       = module.sg_rds.sg_rds_id
}

# Outputs related to RDS instances

# ARN of the RDS instance
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

# Connection endpoint of the RDS instance
output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

# Connection endpoint of the RDS instance (identifier)
output "db_instance_identifier" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_identifier
}

# Outputs related to RDS Subnet Group

# Name of the RDS subnet group
output "main_rds_subnet_group_name" {
  description = "The name of the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_name
}

# Subnet IDs in the RDS subnet group
output "main_rds_subnet_group_subnet_ids" {
  description = "The list of subnet IDs in the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_subnet_ids
}

# Tags of the RDS subnet group
output "main_rds_subnet_group_tags" {
  description = "The tags for the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_tags
}

# Outputs related to RDS replica instances

# ARN of the RDS replica instance
output "replica_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS replica instance."
  value       = module.rds_replica.replica_db_instance_arn
}

# Connection endpoint of the RDS replica instance
output "replica_db_instance_endpoint" {
  description = "The connection endpoint for the RDS replica instance."
  value       = module.rds_replica.replica_db_instance_endpoint
}

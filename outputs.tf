# output "lb_endpoint" {
#   value = "http://${aws_lb.terramino.dns_name}"
# }

# output "application_endpoint" {
#   value = "http://${aws_lb.terramino.dns_name}/index.php"
# }

# output "asg_name" {
#   value = aws_autoscaling_group.terramino.name
# }

# output "rds-url" {
#   value = aws_db_instance.myinstance.endpoint
# }

# output "replica-url" {
#   value=aws_db_instance.replica-myinstance.endpoint
# }

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnet_ids" {
    value = var.public_subnets_cidr
}

output "private_subnet_ids" {
    value = var.public_subnets_cidr
}

output "nat_gateway_ids" {
  value = module.gateways.nat_gateway_ids
}

output "aws_internet_gateway_ids" {
  value = module.gateways.aws_internet_gateway_ids
}

output "private_route_table_ids" {
  value = module.route_tables.private_route_table_ids
}

output "public_route_table_id" {
  value = module.route_tables.public_route_table_id
}

output "auto_scaling_group_launch_configuration_name" {
  description = "The name of the launch configuration from the auto scaling module"
  value       = module.asg_wordpress.launch_configuration_name
}

output "auto_scaling_group_name" {
  description = "The name of the auto scaling group from the auto scaling module"
  value       = module.asg_wordpress.autoscaling_group_name
}

output "launch_configuration_name" {
  description = "The name of the launch configuration from the bastion ASG module."
  value       = module.asg_bastion.launch_configuration_name
}

output "autoscaling_group_name" {
  description = "The name of the auto scaling group from the bastion ASG module."
  value       = module.asg_bastion.autoscaling_group_name
}

output "lb_arn" {
  description = "ARN of the Load Balancer"
  value       = module.lb_wordpress.lb_arn
}

output "lb_dns_name" {
  description = "ARN of the Load Balancer"
  value       = module.lb_wordpress.lb_dns_name
}

output "lb_listener_arn" {
  description = "ARN of the Load Balancer Listener"
  value       = module.lb_wordpress.lb_listener_arn
}

output "lb_target_group_arn" {
  description = "ARN of the Load Balancer Target Group"
  value       = module.lb_wordpress.lb_target_group_arn
}

output "sg_wordpress_id" {
  description = "The ID of the WordPress instance security group"
  value       = module.sg_wordpress.sg_wordpress_id
}

output "sg_bastion_id" {
  description = "The ID of the bastion instance security group"
  value       = module.sg_bastion.sg_bastion_id
}

output "sg_lb_wordpress_id" {
  description = "The ID of the WordPress load balancer security group"
  value       = module.sg_lb_wordpress.sg_lb_wordpress_id
}

output "sg_rds_id" {
  description = "The ID of the RDS security group"
  value       = module.sg_rds.sg_rds_id
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_identifier" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_identifier
}

output "main_rds_subnet_group_name" {
  description = "The name of the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_name
}

output "main_rds_subnet_group_subnet_ids" {
  description = "The list of subnet IDs in the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_subnet_ids
}

output "main_rds_subnet_group_tags" {
  description = "The tags for the RDS subnet group from the module."
  value       = module.subnets.rds_subnet_group_tags
}

output "replica_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS replica instance."
  value       = module.rds_replica.replica_db_instance_arn
}

output "replica_db_instance_endpoint" {
  description = "The connection endpoint for the RDS replica instance."
  value       = module.rds_replica.replica_db_instance_endpoint
}

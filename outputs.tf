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

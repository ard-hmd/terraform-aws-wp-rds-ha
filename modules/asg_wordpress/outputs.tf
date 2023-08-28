output "launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.wordpress.name
}

output "autoscaling_group_name" {
  description = "The name of the auto scaling group"
  value       = aws_autoscaling_group.wordpress.name
}

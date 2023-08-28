# Output: Retrieve the name of the created WordPress Launch Configuration
output "launch_configuration_name" {
  # Brief description of the output
  description = "The name of the launch configuration for the WordPress instance"
  
  # Extract the 'name' attribute from the 'aws_launch_configuration' resource tagged 'wordpress'
  value       = aws_launch_configuration.wordpress.name
}

# Output: Retrieve the name of the created WordPress Auto Scaling Group
output "autoscaling_group_name" {
  # Brief description of the output
  description = "The name of the auto scaling group for the WordPress instance"
  
  # Extract the 'name' attribute from the 'aws_autoscaling_group' resource tagged 'wordpress'
  value       = aws_autoscaling_group.wordpress.name
}

# Output: Retrieve the ID of the created WordPress Auto Scaling Group
output "asg_id" {
  # Brief description of the output
  description = "ID of the Auto Scaling Group for the WordPress instance"
  
  # Extract the 'id' attribute from the 'aws_autoscaling_group' resource tagged 'wordpress'
  value       = aws_autoscaling_group.wordpress.id
}

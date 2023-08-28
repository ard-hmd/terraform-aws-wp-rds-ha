# Output: Retrieve the name of the created Launch Configuration
output "launch_configuration_name" {
  # Description for clarity
  description = "The name of the launch configuration."
  # Extract the 'name' attribute from the 'aws_launch_configuration' resource with the label 'bastion'
  value       = aws_launch_configuration.bastion.name
}

# Output: Retrieve the name of the created Auto Scaling Group
output "autoscaling_group_name" {
  # Description for clarity
  description = "The name of the auto scaling group."
  # Extract the 'name' attribute from the 'aws_autoscaling_group' resource with the label 'bastion'
  value       = aws_autoscaling_group.bastion.name
}

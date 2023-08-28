# Output: ID of the WordPress instance security group
output "sg_wordpress_id" {
  description = "The ID of the WordPress instance security group"  # Describing the purpose of the output
  value       = aws_security_group.wordpress_instance.id  # Extracting the ID of the WordPress instance security group
}

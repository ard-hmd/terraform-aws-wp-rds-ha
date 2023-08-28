output "sg_wordpress_id" {
  description = "The ID of the WordPress instance security group"
  value       = aws_security_group.wordpress_instance.id
}

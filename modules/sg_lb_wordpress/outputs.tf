# Output: ID of the WordPress load balancer security group
output "sg_lb_wordpress_id" {
  description = "The ID of the WordPress load balancer security group"  # Describing the purpose of the output
  value       = aws_security_group.wordpress_lb.id  # Extracting the ID of the WordPress load balancer security group
}

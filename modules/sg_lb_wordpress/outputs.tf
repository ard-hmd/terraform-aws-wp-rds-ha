output "sg_lb_wordpress_id" {
  description = "The ID of the WordPress load balancer security group"
  value       = aws_security_group.wordpress_lb.id
}

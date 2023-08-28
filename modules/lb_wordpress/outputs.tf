# Output: ARN of the Load Balancer
output "lb_arn" {
  description = "ARN of the Load Balancer"  # Describing the purpose of the output
  value       = aws_lb.wordpress.arn  # Extracting ARN of the Load Balancer
}

# Output: DNS Name of the Load Balancer
output "lb_dns_name" {
  description = "DNS Name of the Load Balancer"  # Describing the purpose of the output
  value       = aws_lb.wordpress.dns_name  # Extracting DNS Name of the Load Balancer
}

# Output: ARN of the Load Balancer Listener
output "lb_listener_arn" {
  description = "ARN of the Load Balancer Listener"  # Describing the purpose of the output
  value       = aws_lb_listener.wordpress.arn  # Extracting ARN of the Load Balancer Listener
}

# Output: ARN of the Load Balancer Target Group
output "lb_target_group_arn" {
  description = "ARN of the Load Balancer Target Group"  # Describing the purpose of the output
  value       = aws_lb_target_group.wordpress.arn  # Extracting ARN of the Load Balancer Target Group
}

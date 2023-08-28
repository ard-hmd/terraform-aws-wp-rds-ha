output "lb_arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.wordpress.arn
}

output "lb_listener_arn" {
  description = "ARN of the Load Balancer Listener"
  value       = aws_lb_listener.wordpress.arn
}

output "lb_target_group_arn" {
  description = "ARN of the Load Balancer Target Group"
  value       = aws_lb_target_group.wordpress.arn
}

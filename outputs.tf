output "lb_endpoint" {
  value = "http://${aws_lb.terramino.dns_name}"
}

output "application_endpoint" {
  value = "http://${aws_lb.terramino.dns_name}/index.php"
}

output "asg_name" {
  value = aws_autoscaling_group.terramino.name
}

output "rds-url" {
  value = aws_db_instance.myinstance.endpoint
}

output "replica-url" {
  value=aws_db_instance.replica-myinstance.endpoint
}
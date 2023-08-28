output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.myinstance.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.myinstance.endpoint
}

output "db_instance_identifier" {
  description = "The connection endpoint"
  value       = aws_db_instance.myinstance.identifier
}

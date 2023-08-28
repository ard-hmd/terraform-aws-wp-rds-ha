output "replica_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS replica instance."
  value       = aws_db_instance.replica-myinstance.arn
}

output "replica_db_instance_endpoint" {
  description = "The connection endpoint for the RDS replica instance."
  value       = aws_db_instance.replica-myinstance.endpoint
}

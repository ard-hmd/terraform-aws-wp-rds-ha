# Output: Amazon Resource Name (ARN) of the RDS replica instance
output "replica_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS replica instance."  # Describing the purpose of the output
  value       = aws_db_instance.replica-myinstance.arn  # Extracting the ARN of the replica instance
}

# Output: Connection Endpoint of the RDS replica instance
output "replica_db_instance_endpoint" {
  description = "The connection endpoint for the RDS replica instance."  # Describing the purpose of the output
  value       = aws_db_instance.replica-myinstance.endpoint  # Extracting the connection endpoint of the replica instance
}

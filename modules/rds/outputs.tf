# Output: ARN of the RDS instance
output "db_instance_arn" {
  description = "The ARN of the RDS instance"  # Describing the purpose of the output
  value       = aws_db_instance.myinstance.arn  # Extracting the ARN of the RDS instance
}

# Output: Connection Endpoint of the RDS instance
output "db_instance_endpoint" {
  description = "The connection endpoint"  # Describing the purpose of the output
  value       = aws_db_instance.myinstance.endpoint  # Extracting the connection endpoint
}

# Output: Identifier of the RDS instance
output "db_instance_identifier" {
  description = "The identifier of the RDS instance"  # Describing the purpose of the output
  value       = aws_db_instance.myinstance.identifier  # Extracting the identifier of the RDS instance
}

# Output: ID of the RDS security group
output "sg_rds_id" {
  description = "The ID of the RDS security group"  # Describing the purpose of the output
  value       = aws_security_group.rds_sg.id  # Extracting the ID of the RDS security group
}

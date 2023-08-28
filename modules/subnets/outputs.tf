output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "rds_subnet_group_name" {
  description = "The name of the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_subnet_group_subnet_ids" {
  description = "The list of subnet IDs in the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.subnet_ids
}

output "rds_subnet_group_tags" {
  description = "The tags for the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.tags
}
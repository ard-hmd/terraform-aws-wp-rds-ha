# Output: Retrieve the IDs of the public subnets
output "public_subnet_ids" {
  description = "The list of IDs of the public subnets."
  value       = aws_subnet.public_subnet.*.id
}

# Output: Retrieve the IDs of the private subnets
output "private_subnet_ids" {
  description = "The list of IDs of the private subnets."
  value       = aws_subnet.private_subnet.*.id
}

# Output: Retrieve the name of the RDS subnet group
output "rds_subnet_group_name" {
  description = "The name of the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.name
}

# Output: Retrieve the subnet IDs in the RDS subnet group
output "rds_subnet_group_subnet_ids" {
  description = "The list of subnet IDs in the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.subnet_ids
}

# Output: Retrieve the tags of the RDS subnet group
output "rds_subnet_group_tags" {
  description = "The tags for the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.tags
}

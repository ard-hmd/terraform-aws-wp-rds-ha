# Output: List of private route table IDs
output "private_route_table_ids" {
  value = aws_route_table.private[*].id  # Extracting the IDs of private route tables
}

# Output: Public route table ID
output "public_route_table_id" {
  value = aws_route_table.public.id  # Extracting the ID of the public route table
}

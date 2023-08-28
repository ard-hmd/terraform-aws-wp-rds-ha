output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

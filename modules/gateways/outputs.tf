output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "aws_internet_gateway_ids" {
  value = aws_internet_gateway.ig.id
}

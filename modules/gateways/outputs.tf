# Output: Retrieve the IDs of the created NAT Gateways
output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id  # Extract the 'id' attribute from all NAT Gateways
}

# Output: Retrieve the ID of the created AWS Internet Gateway
output "aws_internet_gateway_ids" {
  value = aws_internet_gateway.ig.id  # Extract the 'id' attribute from the Internet Gateway
}

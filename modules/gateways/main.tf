# Create an AWS Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = var.vpc_id  # Attach the Internet Gateway to the specified VPC

  tags = {
    "Name"        = "${var.environment}-igw"  # Set a meaningful name for the Internet Gateway
    "Environment" = var.environment
  }
}

# Create AWS Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip" {
  count      = length(var.public_subnets_cidr)  # Create an EIP for each public subnet
  vpc        = true
  depends_on = [aws_internet_gateway.ig]  # Ensure Internet Gateway is created first

  tags = {
    Name        = "${var.environment}-nat-eip-${element(var.availability_zones, count.index)}"
    Environment = var.environment
  }
}

# Create AWS NAT Gateways
resource "aws_nat_gateway" "nat" {
  count          = length(var.public_subnets_cidr)  # Create a NAT Gateway for each public subnet
  allocation_id  = element(aws_eip.nat_eip.*.id, count.index)  # Use the EIP ID as the allocation ID
  subnet_id      = element(var.public_subnet_ids, count.index)  # Use the corresponding public subnet

  tags = {
    Name        = "${var.environment}-nat-gateway-${element(var.availability_zones, count.index)}"
    Environment = var.environment
  }
}

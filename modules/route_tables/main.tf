# Create private route tables for each private subnet
resource "aws_route_table" "private" {
  count = length(var.private_subnets_cidr)  # Creating multiple resources based on the count of private subnets
  vpc_id = var.vpc_id  # Associating the route table with the VPC

  tags = {
    Name        = "${var.environment}-private-route-table-${element(var.availability_zones, count.index)}"  # Naming the route table
    Environment = var.environment
  }
}

# Create a public route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id  # Associating the route table with the VPC

  tags = {
    Name        = "${var.environment}-public-route-table"  # Naming the route table
    Environment = var.environment
  }
}

# Create a default route to the Internet Gateway for public subnets
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id  # Associating the route with the public route table
  destination_cidr_block = "0.0.0.0/0"  # Destination CIDR block for the default route
  gateway_id             = var.internet_gateway_id  # Target Internet Gateway
}

# Create a default route to NAT Gateway for private subnets
resource "aws_route" "private_nat_gateway" {
  count                 = length(var.private_subnets_cidr)  # Creating multiple routes based on the count of private subnets
  route_table_id        = element(aws_route_table.private.*.id, count.index)  # Associating the route with the private route table
  destination_cidr_block = "0.0.0.0/0"  # Destination CIDR block for the default route
  nat_gateway_id        = element(var.nat_gateway_ids, count.index)  # Target NAT Gateway
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)  # Associating public subnets with public route table
  subnet_id      = element(var.public_subnet_ids, count.index)  # Subnet to associate
  route_table_id = aws_route_table.public.id  # Route table to associate with
}

# Associate private subnets with their respective private route tables
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)  # Associating private subnets with private route tables
  subnet_id      = element(var.private_subnet_ids, count.index)  # Subnet to associate
  route_table_id = element(aws_route_table.private.*.id, count.index)  # Route table to associate with
}

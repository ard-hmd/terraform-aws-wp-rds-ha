# Create AWS public subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_cidr)  # Create multiple subnets based on the count of provided CIDR blocks
  vpc_id                  = var.vpc_id  # Associate the subnets with the specified VPC
  cidr_block              = element(var.public_subnets_cidr, count.index)  # Use the CIDR block from the list based on the count index
  availability_zone       = element(var.availability_zones, count.index)  # Use the availability zone from the list based on the count index
  map_public_ip_on_launch = true  # Enable automatic public IP assignment for instances launched in this subnet

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"  # Create a unique name for each subnet
    Environment = "${var.environment}"  # Assign the specified environment tag
  }
}

# Create AWS private subnets
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets_cidr)  # Create multiple subnets based on the count of provided CIDR blocks
  vpc_id                  = var.vpc_id  # Associate the subnets with the specified VPC
  cidr_block              = element(var.private_subnets_cidr, count.index)  # Use the CIDR block from the list based on the count index
  availability_zone       = element(var.availability_zones, count.index)  # Use the availability zone from the list based on the count index
  map_public_ip_on_launch = false  # Do not assign automatic public IP addresses

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"  # Create a unique name for each subnet
    Environment = "${var.environment}"  # Assign the specified environment tag
  }
}

# Create RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"  # Name of the RDS subnet group
  subnet_ids = aws_subnet.private_subnet.*.id  # Use the IDs of private subnets for RDS instances

  tags = {
    Name = "Rds Subnet Group"  # Assign a tag to the subnet group
  }
}

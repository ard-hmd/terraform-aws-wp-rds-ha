resource "aws_internet_gateway" "ig" {
  vpc_id = var.vpc_id

  tags = {
    "Name"        = "${var.environment}-igw"
    "Environment" = var.environment
  }
}

resource "aws_eip" "nat_eip" {
  count      = length(var.public_subnets_cidr)
  vpc        = true
  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name        = "${var.environment}-nat-eip-${element(var.availability_zones, count.index)}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  count          = length(var.public_subnets_cidr)
  allocation_id  = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id      = element(var.public_subnet_ids, count.index)

  tags = {
    Name        = "${var.environment}-nat-gateway-${element(var.availability_zones, count.index)}"
    Environment = var.environment
  }
}

# Resource: AWS VPC
resource "aws_vpc" "vpc" {
  # Define the CIDR block for the VPC
  cidr_block           = var.vpc_cidr

  # Enable DNS hostnames for instances in the VPC
  enable_dns_hostnames = true

  # Enable DNS support for the VPC
  enable_dns_support   = true

  # Add tags to the VPC for identification
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

variable "aws_region" {
  default = "eu-west-3"
}

# variable "availability_zones" {
#   default     = ["${aws_region}a", "${aws_region}b"]
#   description = "List of availability zones"
#   type        = list(string)
# }

locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

variable "environment" {
  default = "prod"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.0.0/20", "10.0.128.0/20"]
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.16.0/20", "10.0.144.0/20"]
  description = "CIDR block for Private Subnet"
}


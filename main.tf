# Configuration of required providers and versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# AWS provider configuration
provider "aws" {
  region = var.aws_region
}

# Locals to define availability zones
locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

# VPC Configuration
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Public Subnet Configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}

# Private Subnet Configuration
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "Rds Subnet Group"
  }
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"        = "${var.environment}-igw"
    "Environment" = var.environment
  }
}

# Elastic IP for NAT Configuration
resource "aws_eip" "nat_eip" {
  count      = length(var.public_subnets_cidr)
  vpc        = true
  # Adding a 'depends_on' here to ensure the NAT Gateway is up and running
  # before executing the user data script, allowing it to access the internet
  # and install required packages during instance launch.
  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name        = "${var.environment}-nat-eip-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# NAT Gateway Configuration
resource "aws_nat_gateway" "nat" {
  count          = length(var.public_subnets_cidr)
  allocation_id  = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name        = "${var.environment}-nat-gateway-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# Private Route Table Configuration
resource "aws_route_table" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-private-route-table-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# Public Route Table Configuration
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Route for NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count                 = length(var.private_subnets_cidr)
  route_table_id        = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id        = element(aws_nat_gateway.nat.*.id, count.index)
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Data Source to get the latest Amazon Linux AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-0041b98fa770e38cd"]
  }
}

data "template_file" "init" {
  template = "${file("user-data.sh.tpl")}"

  vars = {
    wp_host = "${aws_db_instance.myinstance.endpoint}"
    wp_user = "${var.db_username}"
    wp_pass = "${var.db_password}"
  }
}

# Launch Configuration for Auto Scaling
resource "aws_launch_configuration" "terramino" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = "t2.micro"
  # user_data       = file("user-data.sh")
  user_data       = "${data.template_file.init.rendered}"
  key_name        = "kp-ahermand"
  security_groups = [aws_security_group.terramino_instance.id]
  depends_on      = [
    aws_nat_gateway.nat,
    aws_db_instance.myinstance
    ]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group Configuration
resource "aws_autoscaling_group" "terramino" {
  name                 = "terramino"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.terramino.name
  vpc_zone_identifier  = aws_subnet.private_subnet.*.id
  health_check_type    = "ELB"

  depends_on = [
    aws_launch_configuration.terramino
  ]

  tag {
    key                 = "Name"
    value               = "HashiCorp Learn ASG - Terramino"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

# Launch Configuration for Auto Scaling
resource "aws_launch_configuration" "bastion" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = "t2.micro"
  key_name        = "kp-ahermand"
  security_groups = [aws_security_group.bastion_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group Configuration
resource "aws_autoscaling_group" "bastion" {
  name                 = "bastion"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.bastion.name
  vpc_zone_identifier  = aws_subnet.public_subnet.*.id
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "HashiCorp Learn ASG - Bastion"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

# Load Balancer Configuration
resource "aws_lb" "terramino" {
  name               = "learn-asg-terramino-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terramino_lb.id]
  subnets            = aws_subnet.public_subnet.*.id
}

# Load Balancer Listener Configuration
resource "aws_lb_listener" "terramino" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = "80"
  protocol          = "HTTP"

  depends_on = [
    aws_autoscaling_group.terramino
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terramino.arn
  }
}

# Load Balancer Target Group Configuration
resource "aws_lb_target_group" "terramino" {
  name     = "learn-asg-terramino"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  depends_on = [
    aws_autoscaling_group.terramino
  ]
}

# Auto Scaling Attachment Configuration
resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.terramino.id
  alb_target_group_arn   = aws_lb_target_group.terramino.arn
}

# Security Group for EC2 Instances
resource "aws_security_group" "terramino_instance" {
  name = "learn-asg-terramino-instance"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_instance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}

# Security Group for EC2 Instances
resource "aws_security_group" "bastion_instance" {
  name = "learn-asg-bastion-instance"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}

# Security Group for Load Balancer
resource "aws_security_group" "terramino_lb" {
  name = "learn-asg-terramino-lb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_instance.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id
}

variable "db_username" {}
variable "db_password" {}

resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  10
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "wpdb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "rds_subnet_group"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  false
  backup_retention_period = 1
  depends_on = [aws_db_subnet_group.rds_subnet_group]
}

resource "aws_db_instance" "replica-myinstance" {
  instance_class       = "db.t2.micro"
  skip_final_snapshot  = true
  backup_retention_period = 0
  replicate_source_db = aws_db_instance.myinstance.identifier
}
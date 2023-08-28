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

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  environment = var.environment
}

module "subnets" {
  source                = "./modules/subnets"
  vpc_id                = module.vpc.vpc_id
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  availability_zones    = local.availability_zones
  environment           = var.environment
}

module "gateways" {
  source              = "./modules/gateways"
  vpc_id              = module.vpc.vpc_id
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = local.availability_zones
  public_subnet_ids   = module.subnets.public_subnet_ids
  environment         = var.environment
}

module "route_tables" {
  source               = "./modules/route_tables"
  vpc_id               = module.vpc.vpc_id
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  availability_zones   = local.availability_zones
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  environment          = var.environment
  internet_gateway_id  = module.gateways.aws_internet_gateway_ids
  nat_gateway_ids      = module.gateways.nat_gateway_ids
}

module "asg_wordpress" {
  source              = "./modules/asg_wordpress"
  wp_host             = "toto"
  # wp_host             = aws_db_instance.myinstance.endpoint
  wp_user             = var.db_username
  wp_pass             = var.db_password
  key_name            = "kp-ahermand"
  security_group_id   = aws_security_group.wordpress_instance.id
  depends_on          = [module.gateways.nat] # pas oublié d'ajouter aws_db_instance.myinstance
  vpc_zone_identifier = module.subnets.private_subnet_ids
}

module "asg_bastion" {
  source              = "./modules/asg_bastion"
  security_group_id   = aws_security_group.bastion_instance.id
  vpc_zone_identifier = module.subnets.public_subnet_ids
}


# # Load Balancer Configuration
# resource "aws_lb" "wordpress" {
#   name               = "learn-asg-wordpress-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.wordpress_lb.id]
#   subnets            = aws_subnet.public_subnet.*.id
# }

# # Load Balancer Listener Configuration
# resource "aws_lb_listener" "wordpress" {
#   load_balancer_arn = aws_lb.wordpress.arn
#   port              = "80"
#   protocol          = "HTTP"

#   depends_on = [
#     aws_autoscaling_group.wordpress
#   ]

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.wordpress.arn
#   }
# }

# # Load Balancer Target Group Configuration
# resource "aws_lb_target_group" "wordpress" {
#   name     = "learn-asg-wordpress"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id

#   depends_on = [
#     aws_autoscaling_group.wordpress
#   ]
# }

# # Auto Scaling Attachment Configuration
# resource "aws_autoscaling_attachment" "wordpress" {
#   autoscaling_group_name = aws_autoscaling_group.wordpress.id
#   alb_target_group_arn   = aws_lb_target_group.wordpress.arn
# }

# Security Group for EC2 Instances
resource "aws_security_group" "wordpress_instance" {
  name = "learn-asg-wordpress-instance"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # security_groups = [aws_security_group.wordpress_lb.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.bastion_instance.id]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
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

  vpc_id = module.vpc.vpc_id
}

# # Security Group for Load Balancer
# resource "aws_security_group" "wordpress_lb" {
#   name = "learn-asg-wordpress-lb"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   vpc_id = aws_vpc.vpc.id
# }

# resource "aws_security_group" "rds_sg" {
#   name = "rds_sg"
#   ingress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.wordpress_instance.id]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   vpc_id = aws_vpc.vpc.id
# }

# variable "db_username" {}
# variable "db_password" {}

# resource "aws_db_instance" "myinstance" {
#   engine               = "mysql"
#   identifier           = "myrdsinstance"
#   allocated_storage    =  10
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   db_name              = "wpdb"
#   username             = var.db_username
#   password             = var.db_password
#   parameter_group_name = "default.mysql5.7"
#   db_subnet_group_name = "rds_subnet_group"
#   vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
#   skip_final_snapshot  = true
#   publicly_accessible =  false
#   backup_retention_period = 1
#   depends_on = [aws_db_subnet_group.rds_subnet_group]
# }

# resource "aws_db_instance" "replica-myinstance" {
#   instance_class       = "db.t2.micro"
#   skip_final_snapshot  = true
#   backup_retention_period = 0
#   replicate_source_db = aws_db_instance.myinstance.identifier
# }
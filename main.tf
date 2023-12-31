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

# VPC Configuration
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  environment = var.environment
}

# Subnets configuration, both private and public
module "subnets" {
  source                = "./modules/subnets"
  vpc_id                = module.vpc.vpc_id
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  availability_zones    = local.availability_zones
  environment           = var.environment
}

# Internet and NAT Gateways configuration for VPC
module "gateways" {
  source              = "./modules/gateways"
  vpc_id              = module.vpc.vpc_id
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = local.availability_zones
  public_subnet_ids   = module.subnets.public_subnet_ids
  environment         = var.environment
}

# Route tables configuration for the VPC
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

# Auto scaling group for the WordPress application
module "asg_wordpress" {
  source              = "./modules/asg_wordpress"
  wp_host             = module.rds.db_instance_endpoint
  wp_user             = var.db_username
  wp_pass             = var.db_password
  key_name            = "kp-ahermand"
  security_group_id   = module.sg_wordpress.sg_wordpress_id
  depends_on          = [module.gateways.nat, module.rds.aws_db_instance]
  vpc_zone_identifier = module.subnets.private_subnet_ids
  user_data_template  = "./modules/asg_wordpress/user-data.sh.tpl"
}

# Auto scaling group for bastion hosts
module "asg_bastion" {
  source              = "./modules/asg_bastion"
  security_group_id   = module.sg_bastion.sg_bastion_id
  vpc_zone_identifier = module.subnets.public_subnet_ids
}

# Load balancer for WordPress application
module "lb_wordpress" {
  source             = "./modules/lb_wordpress"
  lb_name            = "lb-wordpress"
  security_group_id  = module.sg_lb_wordpress.sg_lb_wordpress_id
  public_subnets_ids = module.subnets.public_subnet_ids
  target_group_name  = "lb-tgn-wordpress"
  vpc_id             = module.vpc.vpc_id
  asg_id             = module.asg_wordpress.asg_id
}

# Security group for WordPress application instances
module "sg_wordpress" {
  source                 = "./modules/sg_wordpress"
  vpc_id                 = module.vpc.vpc_id
  wordpress_lb_sg_id     = module.sg_lb_wordpress.sg_lb_wordpress_id
  bastion_instance_sg_id = module.sg_bastion.sg_bastion_id
}

# Security group for bastion hosts
module "sg_bastion" {
  source = "./modules/sg_bastion"
  vpc_id = module.vpc.vpc_id
}

# Security group for WordPress application's load balancer
module "sg_lb_wordpress" {
  source = "./modules/sg_lb_wordpress"
  vpc_id = module.vpc.vpc_id
}

# Security group for the RDS database
module "sg_rds" {
  source                  = "./modules/sg_rds"
  wordpress_instance_sg_id = module.sg_wordpress.sg_wordpress_id
  vpc_id                  = module.vpc.vpc_id
}

# RDS database configuration for WordPress
module "rds" {
  source              = "./modules/rds"
  db_username         = var.db_username
  db_password         = var.db_password
  rds_sg_id           = module.sg_rds.sg_rds_id
  depends_on          = [module.subnets.main_rds_subnet_group_subnet_ids]
}

# RDS replica database configuration
module "rds_replica" {
  source              = "./modules/rds_replica"
  replicate_source_db = module.rds.db_instance_identifier
}

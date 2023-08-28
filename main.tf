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
  wp_host             = module.rds.db_instance_endpoint
  wp_user             = var.db_username
  wp_pass             = var.db_password
  key_name            = "kp-ahermand"
  security_group_id   = module.sg_wordpress.sg_wordpress_id
  depends_on          = [module.gateways.nat, module.rds.aws_db_instance] # pas oublié d'ajouter aws_db_instance.myinstance
  vpc_zone_identifier = module.subnets.private_subnet_ids
}

module "asg_bastion" {
  source              = "./modules/asg_bastion"
  security_group_id   = module.sg_bastion.sg_bastion_id
  vpc_zone_identifier = module.subnets.public_subnet_ids
}


module "lb_wordpress" {
  source             = "./modules/lb_wordpress"
  lb_name            = "lb-wordpress"
  security_group_id  = module.sg_lb_wordpress.sg_lb_wordpress_id
  public_subnets_ids = module.subnets.public_subnet_ids
  target_group_name  = "lb-tgn-wordpress"
  vpc_id             = module.vpc.vpc_id
  asg_id             = module.asg_wordpress.asg_id
}

module "sg_wordpress" {
  source                 = "./modules/sg_wordpress"
  vpc_id                 = module.vpc.vpc_id
  wordpress_lb_sg_id     = module.sg_lb_wordpress.sg_lb_wordpress_id
  bastion_instance_sg_id = module.sg_bastion.sg_bastion_id
}

module "sg_bastion" {
  source = "./modules/sg_bastion"
  vpc_id = module.vpc.vpc_id
}

module "sg_lb_wordpress" {
  source = "./modules/sg_lb_wordpress"
  vpc_id = module.vpc.vpc_id
}

module "sg_rds" {
  source                 = "./modules/sg_rds"
  wordpress_instance_sg_id = module.sg_wordpress.sg_wordpress_id
  vpc_id                 = module.vpc.vpc_id
}

module "rds" {
  source              = "./modules/rds"
  db_username         = var.db_username
  db_password         = var.db_password
  rds_sg_id           = module.sg_rds.sg_rds_id
  depends_on          = [module.subnets.main_rds_subnet_group_subnet_ids]
}

module "rds_replica" {
  source              = "./modules/rds_replica"
  replicate_source_db = module.rds.db_instance_identifier
}

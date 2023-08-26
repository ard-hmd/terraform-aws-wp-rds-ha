# Configuration des fournisseurs et versions requises
terraform {
  # Déclaration des fournisseurs nécessaires et de leurs versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Fournisseur AWS par HashiCorp
      version = "~> 4.16"        # Version minimale 4.16, mais inférieure à 5
    }
  }
  required_version = ">= 1.2.0"   # Version Terraform minimale requise est 1.2.0
}


# Configuration du fournisseur AWS
provider "aws" {
  region = var.aws_region  # Utilise la région spécifiée dans la variable aws_region
}

# Locaux pour définir des zones de disponibilité
locals {
  # Liste des zones de disponibilité basées sur la région spécifiée
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}


# ---------------------
# Configuration du VPC
# ---------------------

# Création d'une ressource AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr              # Plage d'adresses pour le VPC
  enable_dns_hostnames = true                      # Activation des noms d'hôtes DNS
  enable_dns_support   = true                      # Activation du support DNS

  # Balises pour identifier la ressource
  tags = {
    Name        = "${var.environment}-vpc"        # Balise de nom basée sur l'environnement
    Environment = var.environment                  # Balise d'environnement
  }
}


# -------------------------
# Configuration des sous-réseaux
# -------------------------

# Sous-réseau public
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id                              # Associe le sous-réseau au VPC précédemment créé
  count                   = length(var.public_subnets_cidr)             # Crée autant de sous-réseaux que spécifié dans la variable
  cidr_block              = element(var.public_subnets_cidr, count.index)  # Utilise une plage d'adresses spécifique de la variable
  availability_zone       = element(local.availability_zones, count.index)  # Utilise une zone de disponibilité spécifique de la variable
  map_public_ip_on_launch = true                                       # Autorise le mappage d'IP publique lors du lancement

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-public-subnet"  # Nom du sous-réseau basé sur l'environnement et la zone
    Environment = "${var.environment}"                                 # Balise d'environnement
  }
}

# Sous-réseau privé
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id                              # Associe le sous-réseau au VPC précédemment créé
  count                   = length(var.private_subnets_cidr)            # Crée autant de sous-réseaux que spécifié dans la variable
  cidr_block              = element(var.private_subnets_cidr, count.index) # Utilise une plage d'adresses spécifique de la variable
  availability_zone       = element(local.availability_zones, count.index)  # Utilise une zone de disponibilité spécifique de la variable
  map_public_ip_on_launch = false                                      # Désactive le mappage d'IP publique lors du lancement

  tags = {
    Name        = "${var.environment}-${element(local.availability_zones, count.index)}-private-subnet" # Nom du sous-réseau basé sur l'environnement et la zone
    Environment = "${var.environment}"                                 # Balise d'environnement
  }
}

# -------------------------------
# Configuration de la passerelle Internet
# -------------------------------

# Création d'une ressource AWS Internet Gateway (IGW)
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id  # Associe la passerelle Internet au VPC précédemment créé

  tags = {
    "Name"        = "${var.environment}-igw"  # Balise de nom basée sur l'environnement
    "Environment" = var.environment            # Balise d'environnement
  }
}


# ---------------------
# Configuration de NAT
# ---------------------

# # Adresse IP élastique pour NAT
# resource "aws_eip" "nat_eip" {
#   vpc        = true                   # L'adresse IP est associée au VPC
#   depends_on = [aws_internet_gateway.ig]  # Dépend de la création de la passerelle Internet
# }

# # Passerelle NAT
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id  # Utilise l'ID de l'adresse IP élastique créée précédemment
#   subnet_id     = element(aws_subnet.public_subnet.*.id, 0)  # Utilise le premier sous-réseau public

#   tags = {
#     Name        = "nat-gateway-${var.environment}"  # Nom de la passerelle NAT basé sur l'environnement
#     Environment = "${var.environment}"               # Balise d'environnement
#   }
# }

# Adresse IP élastique pour NAT - Création d'une EIP pour chaque sous-réseau public
resource "aws_eip" "nat_eip" {
  count      = length(var.public_subnets_cidr)
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = {
    Name        = "${var.environment}-nat-eip-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# Passerelle NAT - Une NAT Gateway par sous-réseau public
resource "aws_nat_gateway" "nat" {
  count          = length(var.public_subnets_cidr)
  allocation_id  = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  tags = {
    Name        = "${var.environment}-nat-gateway-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# --------------------------------
# Configuration des tables de routage
# --------------------------------

# # Table de routage pour le sous-réseau privé
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.vpc.id  # Associe la table de routage au VPC précédemment créé

#   tags = {
#     Name        = "${var.environment}-private-route-table"  # Nom de la table basé sur l'environnement
#     Environment = "${var.environment}"                      # Balise d'environnement
#   }
# }

resource "aws_route_table" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-private-route-table-${element(local.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

# Table de routage pour le sous-réseau public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id  # Associe la table de routage au VPC précédemment créé

  tags = {
    Name        = "${var.environment}-public-route-table"   # Nom de la table basé sur l'environnement
    Environment = "${var.environment}"                      # Balise d'environnement
  }
}

# Route pour la passerelle Internet
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"  # Toutes les adresses
  gateway_id             = aws_internet_gateway.ig.id  # Utilise la passerelle Internet
}

# # Route pour la passerelle NAT
# resource "aws_route" "private_internet_gateway" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"  # Toutes les adresses
#   gateway_id             = aws_nat_gateway.nat.id  # Utilise la passerelle NAT
# }

resource "aws_route" "private_nat_gateway" {
  count                 = length(var.private_subnets_cidr)
  route_table_id        = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id        = element(aws_nat_gateway.nat.*.id, count.index)
}


# Associations de table de routage pour le sous-réseau public
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)  # Associe à chaque sous-réseau public
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)  # Utilise chaque ID de sous-réseau public
  route_table_id = aws_route_table.public.id  # Utilise la table de routage publique
}

# Associations de table de routage pour le sous-réseau privé
# resource "aws_route_table_association" "private" {
#   count          = length(var.private_subnets_cidr)  # Associe à chaque sous-réseau privé
#   subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)  # Utilise chaque ID de sous-réseau privé
#   route_table_id = aws_route_table.private.id  # Utilise la table de routage privée
# }

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# ---------------------
# Configuration de l'AMI
# ---------------------

# Définition d'une source de données pour obtenir l'AMI Amazon Linux la plus récente
data "aws_ami" "amazon-linux" {
  most_recent = true    # Récupère l'AMI la plus récente
  owners      = ["amazon"]  # Filtre pour les AMI appartenant à Amazon

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]  # Filtre par nom d'AMI spécifique
  }
}

# -------------------------------
# Configuration de l'auto-scaling
# -------------------------------

# Configuration de la création d'instances
resource "aws_launch_configuration" "terramino" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = data.aws_ami.amazon-linux.id  # Utilise l'AMI Amazon Linux
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")  # Utilise un script pour la personnalisation
  key_name        = "kp-ahermand"
  security_groups = [aws_security_group.terramino_instance.id]  # Associe le groupe de sécurité

  # Indique que la création de cette ressource dépend de la passerelle Internet
  depends_on = [aws_nat_gateway.nat]
  
  lifecycle {
    create_before_destroy = true  # Crée avant de détruire pour assurer la continuité
  }
}

# Configuration du groupe d'auto-évolutivité
resource "aws_autoscaling_group" "terramino" {
  name                 = "terramino"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.terramino.name  # Associe la configuration de lancement
  # vpc_zone_identifier  = aws_subnet.public_subnet.*.id  # Utilise les sous-réseaux publics
  vpc_zone_identifier  = aws_subnet.private_subnet.*.id  # Utilise les sous-réseaux privés

  health_check_type = "ELB"  # Vérification de la santé via le Load Balancer

  # Balise pour identifier le groupe d'auto-évolutivité
  tag {
    key                 = "Name"
    value               = "HashiCorp Learn ASG - Terramino"
    propagate_at_launch = true
  }

  lifecycle { 
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

# ---------------------
# Configuration du Load Balancer
# ---------------------

# Configuration du Load Balancer
resource "aws_lb" "terramino" {
  name               = "learn-asg-terramino-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terramino_lb.id]  # Associe le groupe de sécurité
  subnets            = aws_subnet.public_subnet.*.id  # Utilise les sous-réseaux publics
}

# Configuration du Listener du Load Balancer
resource "aws_lb_listener" "terramino" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terramino.arn  # Utilise le groupe de cibles
  }
}

# Configuration du groupe de cibles du Load Balancer
resource "aws_lb_target_group" "terramino" {
  name     = "learn-asg-terramino"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# Configuration de l'attachement du groupe d'auto-évolutivité au groupe de cibles
resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.terramino.id
  alb_target_group_arn   = aws_lb_target_group.terramino.arn
}

# Configuration du groupe de sécurité pour les instances EC2
resource "aws_security_group" "terramino_instance" {
  name = "learn-asg-terramino-instance"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]  # Autorise le trafic depuis le Load Balancer
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id  # Associe le groupe de sécurité au VPC
}

# Configuration du groupe de sécurité pour le Load Balancer
resource "aws_security_group" "terramino_lb" {
  name = "learn-asg-terramino-lb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autorise le trafic depuis toutes les sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id  # Associe le groupe de sécurité au VPC
}

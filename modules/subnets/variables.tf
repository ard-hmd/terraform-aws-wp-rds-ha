variable "vpc_id" {
  description = "ID du VPC dans lequel créer les sous-réseaux"
}

variable "public_subnets_cidr" {
  description = "Liste des blocs CIDR des sous-réseaux publics"
}

variable "private_subnets_cidr" {
  description = "Liste des blocs CIDR des sous-réseaux privés"
}

variable "availability_zones" {
  description = "Liste des zones de disponibilité"
  type        = list(string)
}

variable "environment" {
  description = "Environnement"
  type        = string
}

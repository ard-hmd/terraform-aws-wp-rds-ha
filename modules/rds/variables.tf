variable "identifier" {
  description = "The DB instance identifier"
  default     = "myrdsinstance"
}

variable "allocated_storage" {
  description = "The allocated storage for the DB"
  default     = 10
}

variable "engine_version" {
  description = "The engine version"
  default     = "5.7"
}

variable "instance_class" {
  description = "The DB instance class"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "The name of the database"
  default     = "wpdb"
}

variable "db_username" {
  description = "The username for the DB"
}

variable "db_password" {
  description = "The password for the DB"
  sensitive   = true
}

variable "parameter_group_name" {
  description = "The DB parameter group"
  default     = "default.mysql5.7"
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name"
  default     = "rds_subnet_group"
}

variable "rds_sg_id" {
  description = "The security group ID for the RDS instance"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default     = true
}

variable "publicly_accessible" {
  description = "Determines if the DB instance is publicly accessible"
  default     = false
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained"
  default     = 1
}


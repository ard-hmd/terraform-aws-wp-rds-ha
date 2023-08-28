# Define the DB instance identifier
variable "identifier" {
  description = "The DB instance identifier"  # Describing the purpose of the variable
  default     = "myrdsinstance"  # Providing a default value
}

# Define the allocated storage for the DB
variable "allocated_storage" {
  description = "The allocated storage for the DB"  # Describing the purpose of the variable
  default     = 10  # Providing a default value
}

# Define the engine version
variable "engine_version" {
  description = "The engine version"  # Describing the purpose of the variable
  default     = "5.7"  # Providing a default value
}

# Define the DB instance class
variable "instance_class" {
  description = "The DB instance class"  # Describing the purpose of the variable
  default     = "db.t2.micro"  # Providing a default value
}

# Define the name of the database
variable "db_name" {
  description = "The name of the database"  # Describing the purpose of the variable
  default     = "wpdb"  # Providing a default value
}

# Define the username for the DB
variable "db_username" {
  description = "The username for the DB"  # Describing the purpose of the variable
}

# Define the password for the DB
variable "db_password" {
  description = "The password for the DB"  # Describing the purpose of the variable
  sensitive   = true  # Marking the value as sensitive (masked)
}

# Define the DB parameter group
variable "parameter_group_name" {
  description = "The DB parameter group"  # Describing the purpose of the variable
  default     = "default.mysql5.7"  # Providing a default value
}

# Define the DB subnet group name
variable "db_subnet_group_name" {
  description = "The DB subnet group name"  # Describing the purpose of the variable
  default     = "rds_subnet_group"  # Providing a default value
}

# Define the security group ID for the RDS instance
variable "rds_sg_id" {
  description = "The security group ID for the RDS instance"  # Describing the purpose of the variable
}

# Define whether a final DB snapshot is created before deletion
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"  # Describing the purpose of the variable
  default     = true  # Providing a default value
}

# Define if the DB instance is publicly accessible
variable "publicly_accessible" {
  description = "Determines if the DB instance is publicly accessible"  # Describing the purpose of the variable
  default     = false  # Providing a default value
}

# Define the number of days for automated backups retention
variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained"  # Describing the purpose of the variable
  default     = 1  # Providing a default value
}

variable "instance_class" {
  description = "The DB instance class."
  default     = "db.t2.micro"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained."
  default     = 0
}

variable "replicate_source_db" {
  description = "The identifier of the source DB instance from which to replicate."
  type        = string
}

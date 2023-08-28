resource "aws_db_instance" "replica-myinstance" {
  instance_class       = var.instance_class
  skip_final_snapshot  = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  replicate_source_db = var.replicate_source_db
}

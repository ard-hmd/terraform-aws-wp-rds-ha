# Create an AWS RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"  # Specify the database engine
  identifier           = var.identifier  # Set the identifier for the RDS instance
  allocated_storage    = var.allocated_storage  # Set the allocated storage in GB
  engine_version       = var.engine_version  # Specify the engine version
  instance_class       = var.instance_class  # Set the instance class
  db_name              = var.db_name  # Set the name of the initial database
  username             = var.db_username  # Set the username for the master user
  password             = var.db_password  # Set the password for the master user
  parameter_group_name = var.parameter_group_name  # Set the parameter group for the instance
  db_subnet_group_name = var.db_subnet_group_name  # Set the subnet group for the instance
  vpc_security_group_ids = [var.rds_sg_id]  # Set the security group(s) for the instance
  skip_final_snapshot  = var.skip_final_snapshot  # Specify whether to skip final snapshot on deletion
  publicly_accessible  = var.publicly_accessible  # Set the public accessibility
  backup_retention_period = var.backup_retention_period  # Set the backup retention period in days
}

resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = var.identifier
  allocated_storage    = var.allocated_storage
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = var.parameter_group_name
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot  = var.skip_final_snapshot
  publicly_accessible  = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
}

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
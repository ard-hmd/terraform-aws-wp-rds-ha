# Create an AWS security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"  # Name of the security group
  
  # Define inbound rule to allow incoming MySQL traffic from the WordPress instance security group
  ingress {
    from_port       = 3306  # Port 3306 for MySQL traffic
    to_port         = 3306
    protocol        = "tcp"  # Protocol to allow
    security_groups = [var.wordpress_instance_sg_id]  # Allow traffic from the specified security group
  }

  # Define outbound rules to allow all outbound traffic
  egress {
    from_port   = 0  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination
  }

  vpc_id = var.vpc_id  # Associate the security group with the VPC
}

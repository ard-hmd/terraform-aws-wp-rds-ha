# Create an AWS security group for the WordPress instances
resource "aws_security_group" "wordpress_instance" {
  name = "asg-wordpress-instance"  # Name of the security group

  # Define inbound rule to allow incoming HTTP traffic from the WordPress load balancer security group
  ingress {
    from_port       = 80  # Port 80 for HTTP traffic
    to_port         = 80
    protocol        = "tcp"  # Protocol to allow
    security_groups = [var.wordpress_lb_sg_id]  # Allow traffic from the specified security group
    cidr_blocks     = ["0.0.0.0/0"]  # Allow traffic from any source
  }

  # Define inbound rule to allow incoming SSH traffic from the Bastion instance security group
  ingress {
    from_port       = 22  # Port 22 for SSH traffic
    to_port         = 22
    protocol        = "tcp"  # Protocol to allow
    security_groups = [var.bastion_instance_sg_id]  # Allow traffic from the specified security group
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

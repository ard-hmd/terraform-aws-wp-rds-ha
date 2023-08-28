# Create an AWS security group for the bastion instance
resource "aws_security_group" "bastion_instance" {
  name = "learn-asg-bastion-instance"  # Name of the security group

  # Define inbound rules
  ingress {
    from_port   = 22  # Allow incoming traffic on port 22
    to_port     = 22
    protocol    = "tcp"  # Protocol to allow
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source
  }

  # Define outbound rules
  egress {
    from_port   = 0  # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination
  }

  vpc_id = var.vpc_id  # Associate the security group with the VPC
}

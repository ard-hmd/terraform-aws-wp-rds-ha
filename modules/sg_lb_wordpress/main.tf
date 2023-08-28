# Create an AWS security group for the WordPress load balancer
resource "aws_security_group" "wordpress_lb" {
  name = "asg-wordpress-lb"  # Name of the security group

  # Define inbound rules to allow incoming traffic on port 80
  ingress {
    from_port   = 80  # Port 80 for HTTP traffic
    to_port     = 80
    protocol    = "tcp"  # Protocol to allow
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source
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

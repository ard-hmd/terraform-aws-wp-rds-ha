resource "aws_security_group" "wordpress_instance" {
  name = "learn-asg-wordpress-instance"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.wordpress_lb_sg_id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_instance_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}


# # Security Group for EC2 Instances
# resource "aws_security_group" "wordpress_instance" {
#   name = "learn-asg-wordpress-instance"

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.wordpress_lb.id]
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion_instance.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   vpc_id = module.vpc.vpc_id
# }
# Load Balancer Configuration
resource "aws_lb" "wordpress" {
  name               = var.lb_name  # Set the name of the load balancer
  internal           = false  # Specify whether it's an internal or external load balancer
  load_balancer_type = "application"  # Set the type of the load balancer
  security_groups    = [var.security_group_id]  # Specify security groups for the load balancer
  subnets            = var.public_subnets_ids  # Specify the subnets for the load balancer
}

# Load Balancer Listener Configuration
resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn  # Associate with the created load balancer
  port              = "80"  # Listen on port 80
  protocol          = "HTTP"  # Use HTTP protocol for listener

  default_action {
    type             = "forward"  # Forward traffic to target group
    target_group_arn = aws_lb_target_group.wordpress.arn  # Specify the target group ARN
  }
}

# Load Balancer Target Group Configuration
resource "aws_lb_target_group" "wordpress" {
  name     = var.target_group_name  # Set the name of the target group
  port     = 80  # Specify the port for the target group
  protocol = "HTTP"  # Use HTTP protocol for target group
  vpc_id   = var.vpc_id  # Associate with the specified VPC
}

# Auto Scaling Attachment Configuration
resource "aws_autoscaling_attachment" "wordpress" {
  autoscaling_group_name = var.asg_id  # Attach to the specified Auto Scaling Group
  alb_target_group_arn   = aws_lb_target_group.wordpress.arn  # Attach to the target group
}

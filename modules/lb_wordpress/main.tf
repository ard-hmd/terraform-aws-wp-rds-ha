# Load Balancer Configuration
resource "aws_lb" "wordpress" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets_ids
}

# Load Balancer Listener Configuration
resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}

# Load Balancer Target Group Configuration
resource "aws_lb_target_group" "wordpress" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Auto Scaling Attachment Configuration
resource "aws_autoscaling_attachment" "wordpress" {
  autoscaling_group_name = var.asg_id
  alb_target_group_arn   = aws_lb_target_group.wordpress.arn
}



# # Load Balancer Configuration
# resource "aws_lb" "wordpress" {
#   name               = "learn-asg-wordpress-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.wordpress_lb.id]
#   subnets            = aws_subnet.public_subnet.*.id
# }

# # Load Balancer Listener Configuration
# resource "aws_lb_listener" "wordpress" {
#   load_balancer_arn = aws_lb.wordpress.arn
#   port              = "80"
#   protocol          = "HTTP"

#   depends_on = [
#     aws_autoscaling_group.wordpress
#   ]

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.wordpress.arn
#   }
# }

# # Load Balancer Target Group Configuration
# resource "aws_lb_target_group" "wordpress" {
#   name     = "learn-asg-wordpress"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id

#   depends_on = [
#     aws_autoscaling_group.wordpress
#   ]
# }

# # Auto Scaling Attachment Configuration
# resource "aws_autoscaling_attachment" "wordpress" {
#   autoscaling_group_name = aws_autoscaling_group.wordpress.id
#   alb_target_group_arn   = aws_lb_target_group.wordpress.arn
# }
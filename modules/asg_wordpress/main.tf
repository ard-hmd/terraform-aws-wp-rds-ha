# Data Source to get the latest Amazon Linux AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

data "template_file" "init" {
  template = file(var.user_data_template)

  vars = {
    wp_host = var.wp_host
    wp_user = var.wp_user
    wp_pass = var.wp_pass
  }
}

# Launch Configuration for Auto Scaling
resource "aws_launch_configuration" "wordpress" {
    name_prefix     = "wp-asg-"
    image_id        = data.aws_ami.amazon-linux.id
    instance_type   = var.instance_type
    user_data       = data.template_file.init.rendered
    key_name        = var.key_name
    security_groups = [var.security_group_id]

    lifecycle {
        create_before_destroy = true
    }
  }

# Auto Scaling Group Configuration
resource "aws_autoscaling_group" "wordpress" {
  name                 = "wordpress"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.wordpress.name
  vpc_zone_identifier  = var.vpc_zone_identifier
  health_check_type    = "ELB"

  depends_on = [
    aws_launch_configuration.wordpress
  ]

  tag {
    key                 = "Name"
    value               = "Wordpress"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

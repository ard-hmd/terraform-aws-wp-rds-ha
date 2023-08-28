# Data Source to get the latest Amazon Linux AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

# Launch Configuration for Auto Scaling
resource "aws_launch_configuration" "bastion" {
  name_prefix     = "bastion-asg-"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group Configuration
resource "aws_autoscaling_group" "bastion" {
  name                 = var.asg_name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.bastion.name
  vpc_zone_identifier  = var.vpc_zone_identifier
  health_check_type    = var.health_check_type

  tag {
    key                 = "Name"
    value               = var.asg_tag_name
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

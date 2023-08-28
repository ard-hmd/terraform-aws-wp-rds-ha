# Data Source: Retrieve the latest Amazon Linux AMI 
data "aws_ami" "amazon-linux" {
  # Ensure we get the most recent version
  most_recent = true
  # Filter images owned by Amazon
  owners = ["amazon"]

  # Use a provided variable to filter by specific AMI ID if necessary
  filter {
    name   = "image-id"
    values = [var.ami_id]
  }
}

# Launch Configuration: Defines the settings for EC2 instances launched as part of our ASG
resource "aws_launch_configuration" "bastion" {
  # Using a name prefix ensures unique naming for each configuration
  name_prefix     = "bastion-asg-"
  # Reference the AMI ID from our data source
  image_id        = data.aws_ami.amazon-linux.id
  # Define instance type, key pair, and security groups from provided variables
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.security_group_id]

  # Ensure a new launch configuration is created before the old one is destroyed
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group Configuration: Manages a group of EC2 instances for scalability and high availability
resource "aws_autoscaling_group" "bastion" {
  # Define the ASG name, size constraints, and the associated launch configuration
  name                 = var.asg_name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.bastion.name
  # Specify the VPC subnets where instances should be created
  vpc_zone_identifier  = var.vpc_zone_identifier
  # Define the health check type (e.g., "EC2" or "ELB")
  health_check_type    = var.health_check_type

  # Assign a tag to instances in this ASG
  tag {
    key                 = "Name"
    value               = var.asg_tag_name
    propagate_at_launch = true
  }

  # Ignore any changes to the desired capacity or associated target groups (useful when managing scaling manually or externally)
  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}

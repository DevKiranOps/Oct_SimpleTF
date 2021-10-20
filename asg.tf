data "aws_ami" "mywebimage" {
  most_recent = true
  filter {
    name   = "name"
    values = ["xyzwebimage"]
  }

  
  owners = ["119077514921"] # KiranOps
}

resource "aws_launch_template" "xyz" {
  name_prefix   = "${var.prefix}-${var.env}-web-lb"
  image_id      = data.aws_ami.mywebimage.id
  instance_type = "t2.micro"
  key_name = var.keypair
  vpc_security_group_ids = [aws_security_group.web.id]
}

resource "aws_autoscaling_policy" "xyz" {
  name                   = "${var.prefix}-${var.env}-asg-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  // scaling_adjustment     = 1 
  
  autoscaling_group_name = aws_autoscaling_group.xyz.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }

 
}

resource "aws_autoscaling_group" "xyz" {
  capacity_rebalance  = true
  desired_capacity    = 3
  max_size            = 10
  min_size            = 3
  vpc_zone_identifier = aws_subnet.web.*.id


   target_group_arns = [aws_lb_target_group.test.arn]
    launch_template {
       
        id = aws_launch_template.xyz.id
        version = aws_launch_template.xyz.latest_version
     }
}

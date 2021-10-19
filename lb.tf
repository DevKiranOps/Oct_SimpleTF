resource "random_string" "random" {
  length           = 5
  min_lower        = 5 
  special          = true
  override_special = "*"
  lower            = true
}

resource "aws_s3_bucket" "lb_logs" {
  
  bucket = "lblogs-${random_string.random.result}"
  acl    = "log-delivery-write"

  tags = {
    Name        = "${var.prefix}-${var.env}-vpc"
    Environment = "Dev"
    }
}

resource "aws_lb" "test" {
  name               = "${var.prefix}-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  // access_logs {
  //   bucket  = aws_s3_bucket.lb_logs.bucket
  //   prefix  = "test-lb"
  //   enabled = true
  // }

  tags = {
      Name = "${var.prefix}-${var.env}-vpc"
      Environment = var.env
      owner       = var.owner

  }
}


output "LB_DNS" {
  value = aws_lb.test.dns_name
}
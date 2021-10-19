resource "aws_lb_target_group" "test" {
  name     = "${var.prefix}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.xyz.id

  health_check {
    healthy_threshold = 3
    interval = 10 
    path = "/"
    

  }
}

resource "aws_lb_target_group_attachment" "test" {
  count  =  var.instance_count
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = element(aws_instance.web.*.id, count.index)
  port             = 80
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

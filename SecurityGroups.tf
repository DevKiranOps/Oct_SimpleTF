resource "aws_security_group" "web" {
  name        = "${var.prefix}-${var.env}-web-SG"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.xyz.id
  tags = {
      Name = "${var.prefix}-${var.env}-web-SG"
      Environment = var.env
      owner = var.owner
  }
}


resource "aws_security_group_rule" "HTTP_to_LB" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"  
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id = aws_security_group.web.id
}



resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.web.id

}


resource "aws_security_group_rule" "SSH_TO_BASTION" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.web.id
  source_security_group_id = aws_security_group.bastion.id
}




# Bastion Security Group


resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-${var.env}-bastion-SG"
  description = "Allow SSH to Home"
  vpc_id      = aws_vpc.xyz.id
  tags = {
      Name = "${var.prefix}-${var.env}-bastion-SG"
      Environment = var.env
      owner = var.owner
  }
}

resource "aws_security_group_rule" "SSH" {
  type              = "ingress"
  cidr_blocks       = ["45.117.65.0/24"]  
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.bastion.id
}


resource "aws_security_group_rule" "allow_all_bastion" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.bastion.id

}


resource "aws_security_group" "lb_sg" {
  name        = "${var.prefix}-${var.env}-lb-SG"
  description = "HTTP inbound traffic"
  vpc_id      = aws_vpc.xyz.id
  tags = {
      Name = "${var.prefix}-${var.env}-lb-SG"
      Environment = var.env
      owner = var.owner
  }
}

resource "aws_security_group_rule" "HTTP_LB" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "allow_all_lb" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.lb_sg.id

}




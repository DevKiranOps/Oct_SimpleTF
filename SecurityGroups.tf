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

resource "aws_security_group_rule" "SSH" {
  type              = "ingress"
  cidr_blocks       = ["45.117.65.0/24"]  
  # ingress_cidr_blocks = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = -1
  security_group_id = aws_security_group.web.id
}


resource "aws_security_group_rule" "HTP" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]  
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
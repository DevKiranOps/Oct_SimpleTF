data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "web" {
  subnet_id   = aws_subnet.xyz.id
  security_groups = [aws_security_group.web.id]
  
  tags = {
    Name = "web_nic"
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_instance_size
  
  network_interface {
    network_interface_id = aws_network_interface.web.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }


  tags = {
    Name = "${var.prefix}-${var.env}-web"
    owner = var.owner
    Environment = var.env

  }
}



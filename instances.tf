
data "template_file" "webdata" {
  template =file("${path.module}/Templates/installApache.tpl")
}



data "aws_ami" "mywebimage" {
  most_recent = true
  filter {
    name   = "name"
    values = ["xyzwebimage"]
  }

  
  owners = ["119077514921"] # KiranOps
}



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
  count = var.instance_count 
  subnet_id   = element(aws_subnet.web.*.id, count.index)
  security_groups = [aws_security_group.web.id]
  
  tags = {
    Name = "web_nic-${count.index}"
  }
}


resource "aws_instance" "web" {
  count  =  var.instance_count
  ami           = data.aws_ami.mywebimage.id
  instance_type = var.web_instance_size
  
  network_interface {
    network_interface_id = element(aws_network_interface.web.*.id, count.index)
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
  key_name=var.keypair



  tags = {
    Name = "${var.prefix}-${var.env}-web-${count.index}"
    Environment = var.env

  }
  depends_on = [aws_route_table_association.web]
}



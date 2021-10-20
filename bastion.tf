
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




resource "aws_instance" "bastionHost" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_size
  
  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
  key_name=var.keypair


  tags = {
    Name = "${var.prefix}-${var.env}-bastion"
    Environment = var.env

  }
  depends_on  = [aws_eip.bastion]
}

resource "aws_network_interface" "bastion" {  
  subnet_id   = aws_subnet.bastion.id
  security_groups = [aws_security_group.bastion.id]
  
  tags = {
    Name = "bastion_nic"
  }
}


resource "aws_eip" "bastion" {
  vpc                       = true
  network_interface         = aws_network_interface.bastion.id
  depends_on                = [aws_internet_gateway.xyz]

}
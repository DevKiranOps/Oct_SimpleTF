resource "aws_vpc" "xyz" {

  cidr_block = var.vpc_cidr
  tags = {
      Name = "${var.prefix}-${var.env}-vpc"
      "owner"       = "IT"

  }
}

resource "aws_subnet" "xyz" {
  vpc_id     = aws_vpc.xyz.id
  cidr_block = var.subnet_web_cidr

  tags = {
    Name = "Web"
    Environment = var.env
    owner       = var.owner

  }
}

resource "aws_internet_gateway" "xyz" {
  vpc_id = aws_vpc.xyz.id

  tags = {
    Name = "TFDemo_GW"
    Environment = var.env
    owner       = "IT"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.xyz.id

  route {
    
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.xyz.id
   }

  tags = {
    Name = "TFDemo_Public_RT"
    Environment = var.env
    owner       = "IT"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.xyz.id
  route_table_id = aws_route_table.public.id
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "xyz" {

  cidr_block = var.vpc_cidr
  tags = {
      Name = "${var.prefix}-${var.env}-vpc"
      Environment = var.env
      owner       = var.owner

  }
}

# Internet Gateway 

resource "aws_internet_gateway" "xyz" {
  vpc_id = aws_vpc.xyz.id

  tags = {
    Name = "${var.prefix}-${var.env}-igw"
    Environment = var.env
    owner       = "IT"
  }
}

# NAT Gateway

resource "aws_eip" "xyz" {
  vpc = true
  tags = {
    Name = "${var.prefix}-${var.env}-nat-eip"
  }

}

resource "aws_nat_gateway" "xyz" {
  allocation_id = aws_eip.xyz.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.prefix}-${var.env}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.xyz]
}



resource "aws_subnet" "bastion" {
  vpc_id     = aws_vpc.xyz.id
  cidr_block = var.subnet_bastion_cidr

  tags = {
    Name = "${var.prefix}-${var.env}-bastion"
    Environment = var.env
    owner       = var.owner

  }
}


resource "aws_subnet" "web" {
  count = length(data.aws_availability_zones.available.zone_ids)
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, count.index)
  vpc_id     = aws_vpc.xyz.id
  cidr_block = element(var.web_subnet_CIDRs, count.index )

  tags = {
    Name = "${var.prefix}-${var.env}-web-${count.index}"
    Environment = var.env
    owner       = var.owner

  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.xyz.id

  route {
    
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.xyz.id
   }

  tags = {
    Name = "${var.prefix}-${var.env}-Public_RT"
    Environment = var.env
    owner       = "IT"
  }
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, count.index)
  vpc_id     = aws_vpc.xyz.id
  cidr_block = element(var.public_subnet_CIDRs, count.index )

  tags = {
    Name = "${var.prefix}-${var.env}-public-${count.index}"
    Environment = var.env
    owner       = var.owner

  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.xyz.id

  route {
    
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.xyz.id
   }

  tags = {
    Name = "${var.prefix}-${var.env}-Private_RT"
    Environment = var.env
    owner       = "IT"
  }
}


resource "aws_route_table_association" "web" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = element(aws_subnet.web.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

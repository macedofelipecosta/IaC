resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
    environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.vpc_name
    environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    environment = var.environment
    Name        = "${var.vpc_name}-public-${count.index + 1}"
    #Name        = "${var.vpc_name}-public"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.vpc_name}-private-${count.index + 1}"
    environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.public_subnets) #Crea una NAT GTW por cada subred publica

  allocation_id = aws_eip.nat_eip[count.index].id #Se asocia una EIP a cada NAT Gateway
  #allocation_id = aws_eip.nat_eip.id #Se asocia una EIP a cada NAT Gateway
  subnet_id = aws_subnet.public_subnet[count.index].id
  #subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    #Name        = "${var.vpc_name}-nat-gw-${count.index + 1}"
    Name        = "${var.vpc_name}-nat-gw"
    environment = var.environment
  }
}

#el nat eip asigna ip publica a nat gtw, le permite la salida a internet.
resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnets) #Crea una EIP por cada subred publica
  domain = "vpc"
  tags = {
    #Name = "${var.vpc_name}-nat-eip"
    Name        = "${var.vpc_name}-nat-eip-${count.index + 1}"
    environment = var.environment
  }
}

#PUBLIC ROUTE

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-public-route-table"
    environment = var.environment
  }
}
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#PRIVATE ROUTE 

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-private-route-table-${count.index + 1}"
    environment = var.environment
  }
}
resource "aws_route" "private_route" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id

}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id

}

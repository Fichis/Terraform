#? Creación del Internet Gateway
resource "aws_internet_gateway" "igw-main" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "main"
  }
}

#? Creación de la tabla de enrutamiento pública
resource "aws_route_table" "rt-public" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id
  }

  tags = {
    Name = "rt-private-main"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt-public.id
}
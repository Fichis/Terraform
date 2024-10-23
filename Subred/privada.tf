#? Creación de la IP Elástica
resource "aws_eip" "aws-eip" {
    domain = "vpc"
}

#? Creación del NAT
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.aws-eip.id
  connectivity_type = "public"
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = "NAT-gw-main"
  }

  #! Para asegurarnos que todo funcione,
  #! uso dependencia explícita para crear el internet gateway
  #! y la ip elástica
  depends_on = [aws_eip.aws-eip]
}

#? Creación de la tabla de enrutamiento privada
resource "aws_route_table" "rt-private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-private-main"
  }
}

#? Asociación de la tabla a la subnet
resource "aws_route_table_association" "private-rt-association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_vpc" "upgrad" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "upgrad-vpc"
  }
}
resource "aws_subnet" "upgrad1" {
  vpc_id     = aws_vpc.upgrad.id
  cidr_block = "10.100.1.0/24"

  tags = {
    Name = "private1"
  }
}
resource "aws_subnet" "upgrad2" {
  vpc_id     = aws_vpc.upgrad.id
  cidr_block = "10.100.2.0/24"

  tags = {
    Name = "private2"
  }
}
resource "aws_subnet" "upgrad3" {
  vpc_id     = aws_vpc.upgrad.id
  cidr_block = "10.100.3.0/24"

  tags = {
    Name = "public1"
  }
}
resource "aws_subnet" "upgrad4" {
  vpc_id     = aws_vpc.upgrad.id
  cidr_block = "10.100.4.0/24"

  tags = {
    Name = "public2"
  }
}
resource "aws_internet_gateway" "upg-igw" {
  vpc_id = aws_vpc.upgrad.id

  tags = {
    Name = "upgrad-igw"
  }
}
resource "aws_eip" "eip" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.upgrad3.id

  tags = {
    Name = "upgrad-nat"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.upg-igw]
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.upgrad.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.upg-igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.upgrad.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-route-table"
  }
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.upgrad3.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.upgrad4.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.upgrad1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.upgrad2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_vpc" "best_practice_vpc" {
  cidr_block       = "10.123.0.0/16"  # Private CIDR block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "BestPracticeVPC"
  }
}

resource "aws_subnet" "best_practice_subnet" {
  vpc_id     = aws_vpc.best_practice_vpc.id
  cidr_block = "10.123.1.0/24"

  map_public_ip_on_launch = false

  tags = {
    Name = "BestPracticeSubnet"
  }
}

resource "aws_internet_gateway" "best_practice_igw" {
  vpc_id = aws_vpc.best_practice_vpc.id

  tags = {
    Name = "BestPracticeIGW"
  }
}

resource "aws_route_table" "best_practice_rt" {
  vpc_id = aws_vpc.best_practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.best_practice_igw.id
  }

  tags = {
    Name = "BestPracticeRT"
  }
}

resource "aws_route_table_association" "best_practice_rta" {
  subnet_id      = aws_subnet.best_practice_subnet.id
  route_table_id = aws_route_table.best_practice_rt.id
}

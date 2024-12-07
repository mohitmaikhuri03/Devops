# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Task1"
  }
}

resource "aws_subnet" "pubsubnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public1"
  }
}

resource "aws_subnet" "pubsubnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public2"
  }
}

resource "aws_subnet" "pvtsubnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private1"
  }
}

resource "aws_subnet" "pvtsubnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private2"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.pubsubnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.pubsubnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.pubsubnet1.id
  allocation_id     = aws_eip.nat_eip.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_route"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.pvtsubnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.pvtsubnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow  inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public_security_grp"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow  inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Traffic from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private_security_grp"
  }
}

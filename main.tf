provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "main-nat-gw"
  }
}

resource "aws_eip" "main" {
  domain = "vpc"
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public.id] # Fixed: Use vpc_security_group_ids instead of security_groups
  key_name               = "key"
  tags = {
    Name = "public-instance"
  }
}

resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Allow Vault, Consul and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "vault" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id] # Fixed: Use vpc_security_group_ids instead of security_groups
  key_name               = "key"
  tags = {
    Name = "Vault"
  }
}

resource "aws_instance" "consul" {
  count                  = 3
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  key_name               = "key"
  vpc_security_group_ids = [aws_security_group.private.id] # Fixed: Use vpc_security_group_ids instead of security_groups
  tags = {
    Name = "consul"
  }
}

resource "aws_lb" "vault_lb" {
  name               = "vault-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public1.id]

  tags = {
    Name = "vault-lb"
  }
}

resource "aws_lb_target_group" "vault_tg" {
  name     = "vault-target-group"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 280
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 9
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "vault" {
  target_group_arn = aws_lb_target_group.vault_tg.arn
  target_id        = aws_instance.vault.id
  port             = 8200
}

resource "aws_lb_listener" "vault" {
  load_balancer_arn = aws_lb.vault_lb.arn
  port              = 8200
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault_tg.arn
  }
}

output "public_instance_dns" {
  value = aws_instance.public_instance.public_dns
}

output "vault_instance_dns" {
  value = aws_instance.vault.private_dns
}

output "consul_instances_dns" {
  value = aws_instance.consul.*.private_dns
}


output "vault_lb_dns" {
  value = aws_lb.vault_lb.dns_name
}

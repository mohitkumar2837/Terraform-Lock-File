resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(pathexpand("~/.ssh/ec2-key.pub"))
}


# =========================
# VPC
# =========================

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}


# =========================
# Internet Gateway
# =========================

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}


# =========================
# Public Subnet
# =========================

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}


# =========================
# Public Route Table
# =========================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# =========================
# Route Table Association
# =========================

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public.id
}


# =========================
# Security Group
# =========================

resource "aws_security_group" "my_security_group" {
  name        = "${var.my_environment}terraform-ec2-sg-1"
  description = "Security group for Terraform EC2"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "terraform-ec2-sg-1"
  }
}


# =========================
# Allow HTTP
# =========================

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


# =========================
# Allow SSH
# =========================

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


# =========================
# Allow All Outbound
# =========================

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# =========================
# EC2
# =========================

resource "aws_instance" "my_ec2" {
  count = 4

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2_key.key_name

  user_data = file("script.sh")

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  root_block_device {
    volume_size = var.my_environment == "dev" ? 10 : 20
    volume_type = "gp3"
  }

  tags = {
    Name = "terra-automate-server-${count.index + 1}"
  }
}

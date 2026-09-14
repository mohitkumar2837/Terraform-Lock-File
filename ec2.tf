

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(pathexpand("~/.ssh/ec2-key.pub"))
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource aws_security_group my_security_group  {
  name        = "terraform-ec2-sg-1"
  vpc_id      = aws_vpc.my_vpc.id  # interpolation
  description = "Security group for Terraform EC2"
}

# Inbound & Outbount port rules

  resource aws_vpc_security_group_ingress_rule allow_http  {
    security_group_id = aws_security_group.my_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 80
    ip_protocol       = "tcp"
    to_port           = 80
  }

 
resource aws_vpc_security_group_ingress_rule allow_ssh {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource aws_vpc_security_group_egress_rule allow_all_traffic {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "my-subnet"
  }
}


resource "aws_instance" "my_ec2" {
  
  count = 2

  depends_on = [ aws_key_pair.ec2_key, aws_security_group.my_security_group ]
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.my_subnet.id
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
    Name = "terra-automate-server"
  }
}
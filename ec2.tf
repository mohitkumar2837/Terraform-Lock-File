resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(pathexpand("~/.ssh/ec2-key.pub"))
}

resource "aws_instance" "my_ec21" {
  ami           = var.ami_id
  instance_type = var.instance_type

  key_name = aws_key_pair.ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = var.instance_name
  }
}
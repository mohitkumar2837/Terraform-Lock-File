

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(pathexpand("~/.ssh/ec2-key.pub"))
}


resource "aws_instance" "my_ec2" {

  ami           = var.ami_id
  instance_type = each.value
    for_each = [{
    "ec2-server-micro" = "t3.micro"
    "ec2-server-small" = "t3.small"
}]   

  key_name = aws_key_pair.ec2_key.key_name
  user_data = file("script.sh")

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = each.key
  }
}
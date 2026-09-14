

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file(pathexpand("~/.ssh/ec2-key.pub"))
}

resource aws_default_vpc default {
}



resource "aws_instance" "my_ec2" {
  
  count = 2

  depends_on = [ aws_key_pair.ec2_key, aws_security_group.my_security_group ]
  ami           = var.ami_id
  instance_type = "t3.micro"
   

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
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ec2[*].public_ip
}

output "ec2_public_dns" {
  description = "DNS address of the EC2 instance"
  value       = aws_instance.my_ec2[*].public_dns
}

output "ec2_private_ip" {
  description = "private IP address of the EC2 instance"
  value       = aws_instance.my_ec2[*].private_ip
}
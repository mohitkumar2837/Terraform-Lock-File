output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ec2[*].public_ip
}

output "ec2_public_dns" {
  description = "DNS address of the EC2 instance"
  value       = aws_instance.my_ec2[*].public_dns
}

# output "ec2_private_ip" {
#   description = "private IP address of the EC2 instance"
#   value       = aws_instance.my_ec2[*].private_ip
# }

# output "ec2_public_ip" {
#   value = [  
#     for instance in aws_instance.my_ec2 : instance.public_ip
# ]
# }

  

# output "ec2_public_dns" {
#   value = [  
#     for instance in aws_instance.my_ec2 : instance.public_dns
# ]

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.testbucket.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.my_app_table.name
}

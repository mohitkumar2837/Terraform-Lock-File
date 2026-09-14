variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type = string
  default = "ami-01a00762f46d584a1"
}



# variable "instance_name" {
#   type    = string
#   default = "Terraform-EC2"
# }

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.small", "t3.micro"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t2.small, t2.medium, t3.micro, t3.small, t3.medium."
  }
}

variable "my_environment" {
  description = "Deployment environment (dev, staging, prd)"
  type        = string
  default     = "prd"

  validation {
    condition     = contains(["dev", "staging", "prd"], var.my_environment)
    error_message = "Environment must be one of: dev, staging, prd."
  }
}
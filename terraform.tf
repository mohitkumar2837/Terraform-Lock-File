terraform {
  backend "s3" {
    bucket         = "dev-test-my-app-bucket-d-2026"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}
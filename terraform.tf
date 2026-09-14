terraform {
  backend "s3" {
    bucket         = "dev-test-my-app-bucket-d-2026"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "dev-test-my-app-table-d"
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
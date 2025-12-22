terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
  backend "s3" {
    bucket = "vpc-aws-test"
    key    = "vpc-aws"
    region = "us-east-1"
    dynamodb_table = "vpc-test"
  }
}


provider "aws" {
  region = "us-east-1"
}
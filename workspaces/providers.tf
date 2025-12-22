terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
  backend "s3" {
    bucket = "dev-chandra"
    key    = "workspaces"
    region = "us-east-1"
    dynamodb_table = "dev-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}
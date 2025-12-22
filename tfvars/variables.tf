variable "image_id" {
  default = "ami-09c813fb71547fc4f"
}


variable "instance_names" {
    default = {
        "db-dev" = "t3.small"
        "backend-dev" = "t3.micro"
        "frontend-dev" = "t3.micro"
    }
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "Expense"
    Environment = "DEV"
    Terraform   = "true"

  }
}

variable "domain_name" {
  default = "chandradevops.online"
}

variable "zone_id" {
  default = "Z05118943EFKFG6RGSND0"
}



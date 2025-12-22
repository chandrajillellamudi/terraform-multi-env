#project variables
variable "project_name" {
    default = "Expense"
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


# vpc variables
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "vpc_tags" {
    default = {}
}

# igw variables
variable "igw_tags" {
    default = {}
}

#subnet variables
variable "public_subnet_cidrs" {
   type = list
   validation {
       condition     = length(var.public_subnet_cidrs) == 2
       error_message = "At least two availability zones must be provided."
   }
}
variable "public_subnet_tags" {
    default = {}
}
variable "private_subnet_cidrs" {
   type = list
   validation {
       condition     = length(var.private_subnet_cidrs) == 2
       error_message = "At least two availability zones must be provided."
   }
}
variable "private_subnet_tags" {
    default = {}
}

variable "database_subnet_cidrs" {
   type = list
   validation {
       condition     = length(var.database_subnet_cidrs) == 2
       error_message = "At least two availability zones must be provided."
   }
}
variable "database_subnet_tags" {
    default = {}
}

# db subnet group variables
variable "db_subnet_group_tags" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}

#route table variables
variable "public_route_table_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

# peering variables
variable "is_peering_required" {
    default = false
}
variable "peer_owner_id" {
    default = ""
}
variable "peering_tags" {
    default = {}
}
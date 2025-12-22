variable "instance_type" {
    default = {
    dev = "t3.micro"
    prod = "t3.small"
}
}
variable "image_id" {
  default = "ami-09c813fb71547fc4f"
}


variable "sg_name" {
  default = "allow_ssh"
}

variable "sg_description" {
  default = "Allowing SSH"
}

variable "ssh_port" {
  default = 22
}

variable "protocol" {
  default = "tcp"
}

variable "allow_cidr" {
  default = ["0.0.0.0/0"]
}

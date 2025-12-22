resource "aws_instance" "workspace" {
  ami                    = var.image_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    instance_type         = lookup(var.instance_type, terraform.workspace)
 

  tags = {
    Name = "workspace"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = var.sg_name
  description = var.sg_description

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = var.allow_cidr

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name      = "allow_ssh"
    CreatedBy = "Chandra"
  }
}
  
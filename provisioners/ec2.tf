resource "aws_security_group" "allow_ssh2" {
  name        = "allow_ssh2"
  description = "Allowing ssh access"
 
  ingress {
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
    
    }

  egress {
     from_port        = 0
     to_port          = 0
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
   
   }

  tags = {
    Name = "allow_ssh2"
    CreatedBy = "Chandra"
  }
}


resource "aws_instance" "provisioners" {
  ami = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = [aws_security_group.allow_ssh2.id]
  instance_type = "t3.micro"

  tags = {
    Name = "provisoners"
  }

  provisioner "local-exec" {
    command = "echo  ${self.private_ip} > private_ip.txt" #self is aws_instance.web
  }
  # provisioner "local-exec" {
  #   command = "ansible-playbook -i private_ip.txt web.yaml"
  # }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password   = "DevOps321"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install ansible -y",
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx",
    ]
  }
}
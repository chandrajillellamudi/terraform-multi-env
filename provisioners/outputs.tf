output "public_ip" {
    value = aws_instance.provisioners.public_ip
}
output "private_ip" {
value = aws_instance.myinstance[*].private_ip
}
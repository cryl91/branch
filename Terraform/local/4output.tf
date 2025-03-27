output "public_ip" {
  value = aws_instance.myinstance[0].public_ip
}
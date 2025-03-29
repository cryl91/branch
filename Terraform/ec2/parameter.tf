resource "aws_ssm_parameter" "instance_type" {
  name  = "instance_type"
  type  = "String"
  value = "t2.micro"
}
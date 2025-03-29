# resource "aws_instance" "myinstance" {
#   ami                     = "ami-08b5b3a93ed654d19"
#   instance_type           = "t2.micro"
# }

resource "aws_instance" "myinstance" {
   count = "1"
   ami                     = var.ami_id
   instance_type           = var.instance_name == "mongodb" ? "t2.micro" : "t2.small"
   instance_type = data.aws_ssm_parameter.instance_type.value #to use the parameter store value 
   security_groups = [aws_security_group.sg.name]

    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = var.tags
 } 
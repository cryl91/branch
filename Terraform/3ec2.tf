# resource "aws_instance" "myinstance" {
#   ami                     = "ami-08b5b3a93ed654d19"
#   instance_type           = "t2.micro"
# }

resource "aws_instance" "myinstance" {
   ami                     = var.ami_id
   instance_type           = var.instance_name == "mongodb" ? "t2.micro" : "t3.medium"
   security_groups = [aws_security_group.sg.name]

    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = var.tags
 } 
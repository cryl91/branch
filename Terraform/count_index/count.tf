resource "aws_instance" "myinstance" {
   count = "10"
   ami                     = var.ami_id
   instance_type           = var.instance_name == "mongodb" ? "t2.micro" : "t2.small"
   
    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = {
    name = var.instance_name[count.index]
 } 
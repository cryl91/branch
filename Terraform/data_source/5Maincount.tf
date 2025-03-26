resource "aws_instance" "myinstance" {
   
   ami                     = var.ami_id
   instance_type           = "t2.micro"
   
    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

   } 

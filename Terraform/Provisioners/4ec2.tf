# resource "aws_instance" "myinstance" {
#   ami                     = "ami-08b5b3a93ed654d19"
#   instance_type           = "t2.micro"
# }

resource "aws_instance" "myinstance" {
   ami                     = var.ami_id
   instance_type           = var.instance_type
   #instance_type = data.aws_ssm_parameter.instance_type.value #to use the parameter store value 

    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = var.tags

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > file1"
  }
} 

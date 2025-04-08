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
 } 

 resource "null_resource" "cluster" {
  triggers = {
  instance_id = aws_instance.myinstance.id
   }

#Bootstrap script can run on any instance of the cluster
#So we just choose the first in this case
connection {
  type = "ssh"
  user = "centos"
  password = "devops123"
  host= self.private_ip
}

//to copy the file into a folder
provisioner "file" { 
  source ="catalogue.sh"
  destination = "/tmp/catalogue.sh"
}

//here write the commands that needs to be executed
 provisioner "remote-exec" {
   inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo su /tmp/catalogue.sh ${var.app_version}"
   ]
 }

 }
 
 output "app_version" {
   value = var.app_version  
 }
 
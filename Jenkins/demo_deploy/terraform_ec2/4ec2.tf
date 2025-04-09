# resource "aws_instance" "catalogue" {
#   ami                     = "ami-08b5b3a93ed654d19"
#   instance_type           = "t2.micro"
# }

resource "aws_key_pair" "generated" {
  key_name   = "Terraform"
  public_key = file("terraform.pub")
}

resource "aws_instance" "catalogue" {
   ami                     = var.ami_id
   instance_type           = var.instance_type
   key_name      = aws_key_pair.generated.key_name
   //key_name      = var.key_name //Use name of already created key in aws here
   #instance_type = data.aws_ssm_parameter.instance_type.value #to use the parameter store value 

    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    tags = var.tags
 } 

 resource "null_resource" "cluster" {
   //Be used to trigger actions only when certain inputs change
   triggers = {
   instance_id = aws_instance.catalogue.id
    }

 #Bootstrap script can run on any instance of the cluster
 #So we just choose the first in this case
 connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("terraform.pem") # Path to your private key
  host        = self.private_ip
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
       "sudo su /tmp/catalogue.sh"
    ]
  }

  }
 

 //Stop the instance and take the ami_id and delete instance
  resource "aws_ec2_instance_state" "catalogue_instance" {
   instance_id = aws_instance.catalogue.id
   state       = "stopped"
 }
  //taking ami_id
   resource "aws_ami_from_instance" "catalogue_ami" {
   name = "My_instance's Ami"
   source_instance_id = aws_instance.catalogue.id
 }

 //delete instance using aws command line. But for this to run you must have aws command line installed on the jenkins server
 resource "null_resource" "delete instance" {
   triggers = {
   instance_id = aws_ami_from_instance.catalogue_ami.id
    }

 provisioner "local-exec" {
     command = "aws ec2 terminate-instances --instance-ids aws_instance.catalogue.id"
   }
 }
 //The remaining process is alb steps = load balancer,targetgroup,listener,rule,launch template,autoscaling group,auroscaling policy

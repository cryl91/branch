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
  
  
   #instance_type = data.aws_ssm_parameter.instance_type.value #to use the parameter store value 

    # tags = {
    #   name = "mongodb"
    #   Envirnoment = "dev"
    # }

    user_data = file("catalogue.sh")
    tags = var.tags
 } 


//Stop the instance and take the ami_id and delete instance
 resource "aws_ec2_instance_state" "catalogue_instance" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.cluster ]
}
 //taking ami_id
  resource "aws_ami_from_instance" "catalogue_ami" {
  name = "My_instance's Ami"
  source_instance_id = aws_instance.catalogue.id
}

//delete instance using aws command line. But for this to run you must have aws command line installed on the jenkins server
resource "null_resource" "delete_instance" {
  triggers = {
  instance_id = aws_ami_from_instance.catalogue_ami.id
   }

provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"

  }
 depends_on = [ aws_ami_from_instance.catalogue_ami ]
 
}
//The remaining process is alb steps = load balancer,targetgroup,listener,rule,launch template,autoscaling group,auroscaling policy

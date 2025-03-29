#In this folder you will apply terraform init,plan,apply
module "ec2" { 
source = "../ec2_modules"
ami_id = var.ami_id
instance_type = var.instance_type 
}


output "instance_id" {
  value = module.ec2.pub_ip
}
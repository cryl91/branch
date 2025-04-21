#In this folder you will apply terraform init,plan,apply
module "ec2" { 
source = "../ec2_modules"
#To call github stored modules = "git::<https of github repo>"
ami_id = var.ami_id
instance_type = var.instance_type 
}


output "instance_id" {
  value = module.ec2.pub_ip  #module.module-name.output-variable-name
}
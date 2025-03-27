#In this folder you will apply terraform init,plan,apply
module "ec2" { 
source = "../ec2_modules"
ami_id = "ami-08b5b3a93ed654d19"
instance_type = "t2.micro" 
}
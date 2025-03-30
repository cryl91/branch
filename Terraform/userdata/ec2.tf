module "ec21_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ec21"  
  ami = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  user_data = file("install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
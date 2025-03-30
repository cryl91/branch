module "ec21_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ec21"  
  ami = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.name]
  user_data = file("install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "sg" {
  name = "sg"
  description = "allowing all"
  
  ingress {
    description = "from vpc"
    from_port = 0
    to_port   = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"  #all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
} 
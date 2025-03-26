#To fetch AMI information
data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"] #you can give owner Account id(here aws account id)

filter {
  name = "name"
  values = ["al2023-ami-2023.6.20250303.0-kernel-6.1-x86_64"]

}
}

output "ami_id" {
  value = data.aws_ami.ami.id

}

#To fetch VPC information

data "aws_vpc" "default" {
  default = true 
}

output "vpc_info" {
  value = data.aws_vpc.default
}

#create security group using vpc information
resource "aws_security_group" "sg" {
  name = "sg"
  vpc_id = data.aws_vpc.default.id
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
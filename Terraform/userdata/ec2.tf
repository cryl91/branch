
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
tags = {
    name = "cyril"
    envirnoment = "dev"
}

}

resource "aws_subnet" "subnetpublic" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "subnetprivate" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IG"
  }
}

#public route table will have internet attached
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "RT Public"

  }
}

resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "RT Private"
  }
}

resource "aws_route_table_association" "asspublic" {
  subnet_id      = aws_subnet.subnetpublic.id
  route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "assprivate" {
  subnet_id      = aws_subnet.subnetprivate.id
  route_table_id = aws_route_table.rtprivate.id
}

#Setting up a NAT Gateway for private subnet. 
#It needs 2 things = Elastic IP+ Nat gateway provisioned in public subnet(ie bcase to get internet access)

#Creating Elastic IP
resource "aws_eip" "eip" {
  domain   = "vpc"
}

#Creating NAT Gateway
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnetpublic.id #Public subnet id give here

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ig]
}

#END OF VPC CREATION

#CREATE A SECURITY GROUP
resource "aws_security_group" "sg" {
  name = "sg"
  description = "allowing all"
  vpc_id = aws_vpc.main.id

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


module "ec21_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ec21"  
  ami = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.subnetpublic.id
  user_data = file("install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

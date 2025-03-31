resource "aws_vpc" "main1" {
  cidr_block = "10.1.1.0/24"
tags = {
    name = "cyril"
    envirnoment = "dev"
}

}

resource "aws_subnet" "subnetpublic1" {
  vpc_id     = aws_vpc.main1.id
  cidr_block = "10.1.1.0/25"

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.main1.id

  tags = {
    Name = "IG"
  }
}

#public route table will have internet attached
resource "aws_route_table" "rtpublic1" {
  vpc_id = aws_vpc.main1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig1.id
  }

  tags = {
    Name = "RT Public"

  }
}


resource "aws_route_table_association" "asspublic1" {
  subnet_id      = aws_subnet.subnetpublic1.id
  route_table_id = aws_route_table.rtpublic1.id
}
#END OF VPC CREATION

#CREATE A SECURITY GROUP
resource "aws_security_group" "sg1" {
  name = "sg1"
  description = "allowing all"
  vpc_id = aws_vpc.main1.id

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

resource "aws_instance" "publicinstance1" {
   ami                     = "ami-08b5b3a93ed654d19"
   instance_type           = "t2.micro"
   subnet_id = aws_subnet.subnetpublic1.id
   vpc_security_group_ids = [aws_security_group.sg1.id]
   associate_public_ip_address = "true"
   } 


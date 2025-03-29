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

resource "aws_instance" "publicinstance" {
   ami                     = "ami-08b5b3a93ed654d19"
   instance_type           = "t2.micro"
   subnet_id = aws_subnet.subnetpublic.id
   security_groups = [aws_security_group.sg.name]
   associate_public_ip_address = "true"
   } 


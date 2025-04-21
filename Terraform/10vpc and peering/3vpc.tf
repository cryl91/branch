resource "aws_vpc" "main1" {
  cidr_block = "10.1.1.0/24"
tags = {
    name = "Second"
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
  #Add Route separately beacuse when you add peering route, aws will consider only
  #one route should be there as below and delete the below route. So keep this separately 
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.ig1.id
  # }

  tags = {
    Name = "RT Public"

  }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.rtpublic1.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig1.id
  
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
   associate_public_ip_address = true
   } 

resource "aws_vpc_peering_connection" "Peer" {
  #peer_owner_id = var.peer_owner_id #For now not required as its the AWS account ID. It is not required for the peering connection within the same aws account
  peer_vpc_id   = aws_vpc.main1.id #Requester ID 
  vpc_id        = aws_vpc.main.id #Acceptor ID
  auto_accept = true
}

resource "aws_route" "peering_route1" {
  route_table_id            = aws_route_table.rtpublic1.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.Peer.id
}

resource "aws_route" "peering_route2" {
  route_table_id            = aws_route_table.rtpublic.id
  destination_cidr_block    = "10.0.0.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.Peer.id
}
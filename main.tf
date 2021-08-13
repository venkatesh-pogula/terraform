
resource "aws_vpc" "ntiervpc" {

    cidr_block = var.ntier_vpc_cidr

    tags = {
      "Name" = "ntier"
    }
}

#Create the resoure by using the different i/p s
resource "aws_subnet" "subnets" {
  count = length(var.ntier_subnet_az)
  cidr_block = cidrsubnet(var.ntier_vpc_cidr, 8, count.index)
  availability_zone = var.ntier_subnet_az[count.index]
   vpc_id = aws_vpc.ntiervpc.id
  
    tags = {
      "Name" = var.ntier_subnet_tags[count.index]
    }
}


# Create the internet gate way and attched to vpc
resource "aws_internet_gateway" "ntier-igw" {

  vpc_id = aws_vpc.ntiervpc.id

  tags = {
    "Name" = "ntier-igw"
  }
}

# Create the route table and the assiocate the route to vpc

resource "aws_route_table" "ntier-publicrt" {
  vpc_id = aws_vpc.ntiervpc.id
  route = [  ]

   tags = {
    "Name" = "ntier-publicrt"
  } 
}
# Create the route for internetgateway

resource "aws_route" "niter-publicroute" {
  route_table_id = aws_route_table.ntier-publicrt.id
  destination_cidr_block ="0.0.0.0/0"
  gateway_id = aws_internet_gateway.ntier-igw.id
}

# associate the subnets to route or internet gate way

resource "aws_route_table_association" "web_subnets_assiocate" {
  count = length(var.web_subnet_index)
  subnet_id = aws_subnet.subnets[var.web_subnet_index[count.index]].id
  route_table_id = aws_route_table.ntier-publicrt.id 
}

# Create the securitygrp

resource "aws_security_group" "web_subnet_sg" {
  name = "openhttps"
  description = "this for web subnet gs"
  vpc_id = aws_vpc.ntiervpc.id
   tags = {
     "Name" = "web_subnet_sg"
   }
}
resource "aws_security_group_rule" "websghttp" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_subnet_sg.id
}
resource "aws_security_group_rule" "websgssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_subnet_sg.id
}

resource "aws_instance" "webserver1" {
  ami = "ami-090717c950a5c34d3" # image id of us-west-2
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web_subnet_sg.id]
  subnet_id = aws_subnet.subnets[0].id 

  tags = {
    "Name" = "webserver1"
  }
}
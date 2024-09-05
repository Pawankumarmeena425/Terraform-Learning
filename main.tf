

// Creating EC2 Instance
resource "aws_instance" "vpc-demo-server" {
    ami = var.os-name
    key_name = var.key
    instance_type = var.instance-type

    associate_public_ip_address = true  # Allocates a public IP

    subnet_id = aws_subnet.subnet-demo.id
    vpc_security_group_ids = [aws_security_group.vpc_sg-demo.id]

}

// Creating VPC 
resource "aws_vpc" "vpc-demo" {
  cidr_block = var.vpc-cidr
}

// Creating Subnet
resource "aws_subnet" "subnet-demo" {
  vpc_id     = aws_vpc.vpc-demo.id
  cidr_block = var.subnet1-cidr

  tags = {
    Name = "subnet-demo"
  }
}


// Creating Internet Gateway
resource "aws_internet_gateway" "igw-demo" {
  vpc_id = aws_vpc.vpc-demo.id

  tags = {
    Name = "igw-demo"
  }
}

// Creating Route Table
resource "aws_route_table" "route-table-demo" {
  vpc_id = aws_vpc.vpc-demo.id

  route {
    cidr_block = "0.0.0.0/0" // 0.0.0.0/0 for accessing traffic from anywhere
    gateway_id = aws_internet_gateway.igw-demo.id
  }

  
  tags = {
    Name = "route-table-demo"
  }
}


// Association Subnet with route table
resource "aws_route_table_association" "rt_association-demo" {
  subnet_id      = aws_subnet.subnet-demo.id
  route_table_id = aws_route_table.route-table-demo.id
}


// Security Groups 
resource "aws_security_group" "vpc_sg-demo" {
  name        = "vpc_sg-demo"
  vpc_id      = aws_vpc.vpc-demo.id

  ingress { // ingress -->> Inbound roules
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress { //  egress -->> outbound roules
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
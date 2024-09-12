// Availabiltiy Zone in the Region
data "aws_availability_zones" "example" {
  state = "available"
}

locals {
  za_length = length(data.aws_availability_zones.example.names)
}

// Creating VPC
resource "aws_vpc" "my_aws_infra" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc-infra"
  }
}



// Creating EC2 Instance For Public Subnet 
resource "aws_instance" "my_infra_instance_public" {
  count         = min(var.public_subnet_no, local.za_length)
  ami           = var.instance_ami
  key_name      = var.instance_security_key
  instance_type = lookup(var.instance_type, element(data.aws_availability_zones.example.names, count.index), "t2.micro")
  subnet_id     = aws_subnet.public_subnet[count.index].id

  associate_public_ip_address = true # Allocates a public IP
  vpc_security_group_ids      = [aws_security_group.instance_security_group.id]
  tags = {
    Name = "MyInstance-PublicSubnet-${element(data.aws_availability_zones.example.names, count.index)}"
  }

}

// Creating EC2 Instance For Private Subnet 
resource "aws_instance" "my_infra_instance_priavte" {
  count         = var.private_subnet_no
  ami           = var.instance_ami
  key_name      = var.instance_security_key
  instance_type = lookup(var.instance_type, element(data.aws_availability_zones.example.names, count.index), "t2.micro")
  subnet_id     = aws_subnet.private_subnet[count.index].id

  # associate_public_ip_address = true # Allocates a public IP
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]

  tags = {
    Name = "MyInstance-PrivateSubnet-${element(data.aws_availability_zones.example.names, count.index)}"
  }
}




/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_aws_infra.id
  count  = min(var.public_subnet_no, local.za_length)
  # cidr_block              = var.vpc_cidr
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.example.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${element(data.aws_availability_zones.example.names, count.index)}- public-subnet"
  }
}


/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_aws_infra.id
  count                   = var.private_subnet_no
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 100 + count.index)
  availability_zone       = element(data.aws_availability_zones.example.names, count.index % local.za_length)
  map_public_ip_on_launch = false
  tags = {
    Name = "${element(data.aws_availability_zones.example.names, count.index)}- private-subnet"
  }
}


// Security Groups For Instance 
resource "aws_security_group" "instance_security_group" {
  name   = "isntance_sg"
  vpc_id = aws_vpc.my_aws_infra.id

  ingress { // ingress -->> Inbound roules
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

// Nacl Security Group for Public Subnet 
resource "aws_network_acl" "nacl-public" {
  vpc_id = aws_vpc.my_aws_infra.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "nacl-public-subnet"
  }
}

// Nacl Security Group for Private Subnet 
resource "aws_network_acl" "nacl-private" {
  vpc_id = aws_vpc.my_aws_infra.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "nacl-private-subnet"
  }
}

// Public Subnet Association with NACL
resource "aws_network_acl_association" "association-public-sub" {
  network_acl_id = aws_network_acl.nacl-public.id
  count          = min(var.public_subnet_no, local.za_length)
  subnet_id      = aws_subnet.public_subnet[count.index].id

}

// Private Subnet Association with NACL
resource "aws_network_acl_association" "association-private-sub" {
  network_acl_id = aws_network_acl.nacl-private.id
  count          = var.private_subnet_no
  subnet_id      = aws_subnet.private_subnet[count.index].id

}


// Route Table Creation For Public Subnet

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.my_aws_infra.id
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "lcoal"
  }
  tags = {
    Name = "public-rt"
  }
}

// Route Table Creation For Private Subnet
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.my_aws_infra.id
  route {
    cidr_block = var.vpc_cidr
    gateway_id =  "local"
  }
  tags = {
    Name = "private-rt"
  }
}

// Create Internet Gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_aws_infra.id
  tags = {
    Name = "my-infra-ig"
  }
}

// Public Route Table Association 
resource "aws_route_table_association" "ig_association_public" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "subnet_association_public" {
  count          = min(var.public_subnet_no, local.za_length)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt-public.id
}

// Private  Route Table Association 
resource "aws_route_table_association" "ig_association_private" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.rt-private.id
}
resource "aws_route_table_association" "subnet_association_private" {
  count          = var.private_subnet_no
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.rt-private.id
}


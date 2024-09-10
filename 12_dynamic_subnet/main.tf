// Creating EC2 Instance
resource "aws_instance" "vpc-demo-server" {
  count         = var.instance_count
  ami           = var.instance_ami
  key_name      = var.key
  instance_type = var.instance-type

  subnet_id = aws_subnet.my_subnet[count.index].id

  associate_public_ip_address = true # Allocates a public IP

  vpc_security_group_ids = [aws_security_group.vpc_sg-demo.id]

}

// Creating VPC 
resource "aws_vpc" "vpc-demo" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "vpc-demo"
  }
}




# Dynamic Subnet Creating
resource "aws_subnet" "my_subnet" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    Nmae = "Dynamic-subnet-${count.index}"
  }


}

// Security Groups 
resource "aws_security_group" "vpc_sg-demo" {
  name   = "vpc_sg-demo"
  vpc_id = aws_vpc.vpc-demo.id

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

//  Creating subent using dynamic , make 5 subnet with the help of vpc slider.


data "aws_key_pair" "my_key_pair" {
  key_name           = "aws-terraform-test"
  include_public_key = true


#   filter {
#     name   = "tag:Component"
#     values = ["web"]
#   }
}


# EC2 Instance using the existing key pair
resource "aws_instance" "my_instance-demo" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.my_key_pair.key_name  # Use the key pair from data source

  tags = {
    Name = "my-ec2-instance"
  }
}


output "fingerprint" {
  value = data.aws_key_pair.my_key_pair.fingerprint
}

output "name" {
  value = data.aws_key_pair.my_key_pair.key_name
}

output "id" {
  value = data.aws_key_pair.my_key_pair.id
}

# provider "aws" {
#   region =  "us-east-1"
#   access_key = var.access_key
#   secret_key =  var.secret_key
# }

# variable "access_key" {
#   type = string
# }
# variable "secret_key" {
#   type = string
# }

data "aws_ami" "Linux" {
#   executable_users = ["self"]
  most_recent      = true
#   name_regex       = "^myami-\\d{3}"
  owners           = ["137112412989"]

#   al2023-ami-2023.5.20240903.0-kernel-6.1-x86_64


  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240903.0-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = "Value of Linux ami id : ${data.aws_ami.Linux.id}"
}
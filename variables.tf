variable "region" {
    type = string
  default = "us-east-1"
}

variable "os-name" {
    type = string
  default =  "ami-066784287e358dad1"
}

variable "instance-type" {
    type = string
  default = "t2.micro"
}

variable "key" {
    type = string
  default = "aws-terraform-test"
}

variable "vpc-cidr" {
    type = string
  default = "10.10.0.0/16"
}

variable "subnet1-cidr" {
    type = string
  default = "10.10.1.0/24"
}
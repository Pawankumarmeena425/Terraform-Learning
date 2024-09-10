

// 
variable "region" {
    type = string
  default = "us-east-1"
}

variable "instance_ami" {

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

  default = "10.0.0.0/16"
}

variable "subnet-cidr" {
    # type = list
  default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "instance_count"{
type  = number
    default =   1
}
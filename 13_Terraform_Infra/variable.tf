variable "public_subnet_no" {
  type = number
  default = 0

}
variable "private_subnet_no" {
  type = number
  default = 0
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_ami" {
  type    = string
  default = "ami-0e53db6fd757e38c7"
}
variable "instance_security_key" {
  type = string
  default = "terraform-learning"
}
variable "instance_type" {
  type = map
    default     = {
    ap-south-1b = "t2.micro"
    ap-south-1a = "t2.micro"
    ap-south-1c = "t3.micro"
  }

}

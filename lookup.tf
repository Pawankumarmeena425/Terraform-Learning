variable "userage" {
  type = map
  default = {
    gaurav  =30
    saurav = 20
  }
}

variable "username" {
  type = string
}

output "username" {
  value = "my name is ${var.username} and my age is ${lookup(var.userage ,var.username)}"
}
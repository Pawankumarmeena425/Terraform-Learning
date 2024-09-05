variable "age" {
  type = number
}

variable "username" {
  type = string
}

output "printname" {
  value = "hello , ${var.username} your age is : ${var.age}"
}

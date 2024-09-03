

resource "aws_instance" "demo-server" {
    ami = "ami-02b49a24cfb95941c"
    key_name ="Security_Group_Testing"
    instance_type = "t2.micro"
}

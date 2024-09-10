// Ouptput the public IPs of the EC2 instance
output "instance_public_ips" {
  value = aws_instance.vpc-demo-server[*].public_ip
}

// output the subnet IDs
output "subnet_ids" {
  value = aws_subnet.subnet-demo[*].id
}

// Output the Vpc ids
output "vpc_id" {
  value = aws_vpc.vpc-demo.id
}
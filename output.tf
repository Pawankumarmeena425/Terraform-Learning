# Output for the public IP of the EC2 instance
output "instance_public_ip" {
  value       = aws_instance.vpc-demo-server.public_ip
  description = "The public IP address of the EC2 instance"
}

# Output for the private IP of the EC2 instance
output "instance_private_ip" {
  value       = aws_instance.vpc-demo-server.private_ip
  description = "The private IP address of the EC2 instance"
}

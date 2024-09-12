output "total_az" {
  # value = data.aws_availability_zones.example.names[1]
    value =length( data.aws_availability_zones.example.names)

}
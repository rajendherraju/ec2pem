output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "instance_id" {
  value = aws_instance.private_ec2.id
}

output "security_group_id" {
  value = aws_security_group.private_ec2_sg.id
}
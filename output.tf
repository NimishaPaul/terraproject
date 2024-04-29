output "security_group_id" {
  value       = aws_security_group.project.id
  description = "The ID of the created security group"
}
output "instance_id" {
  value       = aws_instance.web001.id
  description = "The ID of the created instance"
}

output "instance_public_ip" {
  value       = aws_instance.web001.public_ip
  description = "The public IP address of the created instance"
}

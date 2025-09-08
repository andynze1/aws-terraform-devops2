output "public_ip" {
  description = "Jenkins instance public IP"
  value       = aws_instance.jenkins.public_ip
}

output "instance_id" {
  description = "Jenkins instance ID"
  value       = aws_instance.jenkins.id
}


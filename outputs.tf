output "ec2_public_ip" {
  description = "Public IP of the Strapi EC2 instance"
  value       = aws_instance.strapi_app.public_ip
}

output "strapi_url" {
  description = "URL to access Strapi (after installation completes)"
  value       = "http://${aws_instance.strapi_app.public_ip}:1337"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i <path-to-your-key.pem> ubuntu@${aws_instance.strapi_app.public_ip}"
}

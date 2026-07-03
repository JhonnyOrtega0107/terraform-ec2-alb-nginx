##############################################################################
# modules/ec2/outputs.tf
##############################################################################

output "instance_id" {
  description = "ID de la instancia EC2."
  value       = aws_instance.web.id
}

output "private_ip" {
  description = "IP privada de la instancia EC2."
  value       = aws_instance.web.private_ip
}

output "ami_used" {
  description = "AMI utilizada en la instancia."
  value       = local.resolved_ami
}

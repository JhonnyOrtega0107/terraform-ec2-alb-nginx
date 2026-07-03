##############################################################################
# outputs.tf
# Valores útiles que se muestran tras un terraform apply exitoso.
##############################################################################

output "alb_dns_name" {
  description = "DNS público del Application Load Balancer. Úsalo en el navegador."
  value       = "http://${aws_lb.main.dns_name}"
}

output "alb_arn" {
  description = "ARN del Application Load Balancer."
  value       = aws_lb.main.arn
}

output "ec2_instance_id" {
  description = "ID de la instancia EC2."
  value       = aws_instance.web.id
}

output "ec2_private_ip" {
  description = "IP privada de la instancia EC2."
  value       = aws_instance.web.private_ip
}

output "vpc_id" {
  description = "ID de la VPC creada."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas."
  value       = aws_subnet.private[*].id
}

output "ami_used" {
  description = "AMI utilizada en la instancia EC2."
  value       = local.resolved_ami
}

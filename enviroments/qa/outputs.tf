##############################################################################
# outputs.tf  –  Root module
# Agrega los outputs de todos los módulos en un solo lugar.
##############################################################################

# ── ALB ──────────────────────────────────────────────────────────────────────

output "alb_url" {
  description = "URL pública del Application Load Balancer. Abre esto en el navegador."
  value       = "http://${module.alb.alb_dns_name}"
}

output "alb_arn" {
  description = "ARN del Application Load Balancer."
  value       = module.alb.alb_arn
}

# ── EC2 ──────────────────────────────────────────────────────────────────────

output "ec2_instance_id" {
  description = "ID de la instancia EC2."
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "IP privada de la instancia EC2."
  value       = module.ec2.private_ip
}

output "ami_used" {
  description = "AMI utilizada en la instancia EC2."
  value       = module.ec2.ami_used
}

# ── Red ──────────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID de la VPC creada."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas."
  value       = module.networking.private_subnet_ids
}

##############################################################################
# modules/security_groups/outputs.tf
##############################################################################

output "alb_sg_id" {
  description = "ID del Security Group del ALB."
  value       = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "ID del Security Group de la EC2."
  value       = aws_security_group.ec2.id
}

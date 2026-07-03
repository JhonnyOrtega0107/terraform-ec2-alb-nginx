##############################################################################
# modules/alb/variables.tf
##############################################################################

variable "project_name" {
  description = "Prefijo usado en los nombres de los recursos."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde vive el Target Group."
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs de las subnets públicas donde se despliega el ALB."
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del Security Group asignado al ALB."
  type        = string
}

variable "target_instance_id" {
  description = "ID de la instancia EC2 que se registra en el Target Group."
  type        = string
}

variable "health_check_path" {
  description = "Path del health check del ALB."
  type        = string
  default     = "/"
}

variable "alb_deletion_protection" {
  description = "Habilita protección contra borrado accidental del ALB."
  type        = bool
  default     = false
}

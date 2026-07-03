##############################################################################
# modules/security_groups/variables.tf
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
  description = "ID de la VPC donde se crean los Security Groups."
  type        = string
}

variable "key_pair_name" {
  description = "Si se proporciona un valor, se abre el puerto 22 en el SG de la EC2."
  type        = string
  default     = ""
}

##############################################################################
# modules/networking/variables.tf
##############################################################################

variable "project_name" {
  description = "Prefijo usado en los nombres de los recursos."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para subnets públicas (mínimo 2 para el ALB)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para subnets privadas (EC2)."
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidad. Debe coincidir en cantidad con las subnets."
  type        = list(string)
}

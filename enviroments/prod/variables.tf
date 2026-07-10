##############################################################################
# variables.tf  –  Root module
# Solo declara las variables que el root module expone hacia afuera.
# Cada módulo tiene sus propias variables internas en modules/<name>/variables.tf
##############################################################################

# ── General ──────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "Región de AWS donde se despliegan los recursos."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto. Se usa como prefijo en los nombres de recursos."
  type        = string
  default     = "nginx-demo"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser dev, staging o prod."
  }
}

# ── Red ──────────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para subnets públicas (mínimo 2 para el ALB)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para subnets privadas (EC2)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Zonas de disponibilidad. Debe coincidir en cantidad con las subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ── EC2 ──────────────────────────────────────────────────────────────────────

variable "instance_type" {
  description = "Tipo de instancia EC2."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID. Si queda vacío se resuelve automáticamente con Amazon Linux 2023."
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "Nombre del Key Pair existente para acceso SSH (opcional)."
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Tamaño del volumen raíz de la EC2 en GiB."
  type        = number
  default     = 30
}

# ── ALB ──────────────────────────────────────────────────────────────────────

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

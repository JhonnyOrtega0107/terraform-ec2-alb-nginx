##############################################################################
# modules/ec2/variables.tf
##############################################################################

variable "project_name" {
  description = "Prefijo usado en los nombres de los recursos."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)."
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet privada donde se lanza la instancia."
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group que se asigna a la instancia."
  type        = string
}

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
  description = "Tamaño del volumen raíz en GiB."
  type        = number
  default     = 20
}

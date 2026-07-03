##############################################################################
# terraform.tfvars  –  Valores del entorno dev
# No subas este archivo si contiene información sensible.
##############################################################################

aws_region   = "us-east-1"
project_name = "nginx-demo"
environment  = "dev"

# Red
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# EC2
instance_type    = "t3.micro"
root_volume_size = 30
key_pair_name    = ""   # Pon aquí el nombre de tu key pair si necesitas SSH

# ALB
health_check_path       = "/"
alb_deletion_protection = false

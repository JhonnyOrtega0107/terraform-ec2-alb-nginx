##############################################################################
# backend.tf
# Configura el estado remoto en S3 con bloqueo nativo via archivo .tflock.
#
# PRE-REQUISITOS (una sola vez):
#
#   # 1. Crear el bucket
#   aws s3api create-bucket \
#     --bucket <YOUR_STATE_BUCKET> \
#     --region us-east-1
#
#   # 2. Habilitar versionado (obligatorio para use_lockfile)
#   aws s3api put-bucket-versioning \
#     --bucket <YOUR_STATE_BUCKET> \
#     --versioning-configuration Status=Enabled
#
# NO se necesita tabla DynamoDB. El lock se gestiona con un archivo
# .tflock en el mismo bucket S3 usando operaciones atómicas de S3.
##############################################################################

terraform {
  backend "s3" {
    bucket       = "terraform-state-s3-devops-bexty"
    key          = "ec2-alb-nginx/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # Lock nativo en S3, reemplaza dynamodb_table (deprecado)
  }
}

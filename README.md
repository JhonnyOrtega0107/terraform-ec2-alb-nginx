# terraform-ec2-alb-nginx

Infraestructura AWS con Terraform que despliega una instancia EC2 con Nginx detrás de un Application Load Balancer público.

## Arquitectura

```
Internet
   │
   ▼
[ALB – público]  (subnets públicas, us-east-1a / us-east-1b)
   │  HTTP :80
   ▼
[EC2 – Nginx]    (subnet privada, Amazon Linux 2023)
   │
   ▼ (salida vía NAT Gateway)
Internet
```

## Recursos creados

| Recurso | Descripción |
|---------|-------------|
| VPC | 10.0.0.0/16 con DNS habilitado |
| Subnets públicas | 2 × /24 para el ALB |
| Subnets privadas | 2 × /24 para la EC2 |
| Internet Gateway | Entrada/salida de subnets públicas |
| NAT Gateway | Salida a internet desde subnets privadas |
| ALB | Balanceador público con health check |
| Target Group | Registro de la EC2 en puerto 80 |
| Listener HTTP | Reenvía tráfico del ALB al Target Group |
| EC2 (t3.micro) | Amazon Linux 2023 + Nginx + index.html |
| IAM Role | SSM Session Manager (sin necesidad de SSH) |
| Security Groups | Mínimo privilegio (ALB → EC2 solo HTTP) |
| Remote State | S3 + DynamoDB lock |

## Pre-requisitos

- [Terraform >= 1.6.0](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configurado (`aws configure`)
- Bucket S3 y tabla DynamoDB para el estado remoto (ver `backend.tf`)

### Crear recursos para el backend (una sola vez)

```bash
# Bucket S3
aws s3api create-bucket --bucket my-terraform-state-bucket --region us-east-1
aws s3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Tabla DynamoDB para locks
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

Luego actualiza los valores en `backend.tf`.

## Uso

```bash
# 1. Inicializar (descarga providers y conecta backend)
terraform init

# 2. Previsualizar cambios
terraform plan

# 3. Aplicar
terraform apply

# 4. Ver la URL del ALB en los outputs
terraform output alb_dns_name
```

Abre la URL en el navegador y verás la página Nginx personalizada.

## Variables principales

| Variable | Default | Descripción |
|----------|---------|-------------|
| `aws_region` | `us-east-1` | Región de despliegue |
| `project_name` | `nginx-demo` | Prefijo de nombres |
| `environment` | `dev` | dev / staging / prod |
| `instance_type` | `t3.micro` | Tipo de instancia EC2 |
| `key_pair_name` | `""` | Key Pair SSH (opcional) |

## Destruir la infraestructura

```bash
terraform destroy
```

## Mejores prácticas aplicadas

- Estado remoto cifrado en S3 con bloqueo DynamoDB
- IMDSv2 obligatorio en la EC2
- Volumen EBS cifrado (gp3)
- Security Groups con mínimo privilegio (la EC2 no está expuesta a internet)
- EC2 en subnet privada, acceso web solo a través del ALB
- IAM Role con SSM (evita abrir puertos SSH)
- Tags automáticos en todos los recursos vía `default_tags`
- Versiones de provider fijadas (`~> 5.0`)
- `terraform.tfvars` separado de `variables.tf`

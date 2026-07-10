##############################################################################
# modules/ec2/main.tf
# Instancia EC2 en subnet privada con Nginx y página index.html.
# Usa IMDSv2, EBS cifrado e IAM Role con SSM (sin SSH obligatorio).
##############################################################################

# ── Data source: última AMI Amazon Linux 2023 ─────────────────────────────────

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  resolved_ami = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id

  user_data = <<-EOF
    #!/bin/bash
    set -e

    dnf update -y
    dnf install -y nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>Nginx en AWS EC2</title>
      <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          background: #0f172a;
          color: #e2e8f0;
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 100vh;
        }
        .card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 2.5rem 3rem;
          max-width: 520px;
          text-align: center;
          box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        }
        .badge {
          display: inline-block;
          background: #10b981;
          color: #fff;
          font-size: 0.75rem;
          font-weight: 600;
          letter-spacing: 0.05em;
          padding: 0.25rem 0.75rem;
          border-radius: 9999px;
          margin-bottom: 1.25rem;
          text-transform: uppercase;
        }
        h1 { font-size: 1.875rem; font-weight: 700; margin-bottom: 0.75rem; }
        p  { color: #94a3b8; line-height: 1.6; margin-bottom: 0.5rem; }
        .info {
          margin-top: 1.5rem;
          background: #0f172a;
          border-radius: 8px;
          padding: 1rem;
          font-size: 0.875rem;
          color: #64748b;
        }
        .info span { color: #38bdf8; font-weight: 600; }
      </style>
    </head>
    <body>
      <div class="card">
        <div class="badge">Activo</div>
        <h1>Hola desde Nginx ${var.environment}</h1>
        <p>Servidor web desplegado con <strong>Terraform</strong> en AWS EC2.</p>
        <p>Balanceo de carga a cargo del <strong>Application Load Balancer</strong>.</p>
        <div class="info">
          Proyecto: <span>${var.project_name}</span> &nbsp;|&nbsp;
          Entorno: <span>${var.environment}</span>
        </div>
      </div>
    </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl start nginx
  EOF
}

# ── IAM Role + SSM (acceso sin SSH) ──────────────────────────────────────────

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# ── Instancia EC2 ─────────────────────────────────────────────────────────────

resource "aws_instance" "web" {
  ami                    = local.resolved_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  key_name               = trimspace(var.key_pair_name) != "" ? trimspace(var.key_pair_name) : null

  user_data                   = base64encode(local.user_data)
  user_data_replace_on_change = true

  # IMDSv2 obligatorio (best practice de seguridad)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-${var.environment}-ec2-root-ebs"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web-server"
  }
}

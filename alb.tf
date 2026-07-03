##############################################################################
# alb.tf
# Application Load Balancer público, Target Group y Listener HTTP.
##############################################################################

# ── Application Load Balancer ─────────────────────────────────────────────────

resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = var.alb_deletion_protection

  # Access logs (descomenta y ajusta si tienes un bucket de logs)
  # access_logs {
  #   bucket  = "my-alb-logs-bucket"
  #   prefix  = "${var.project_name}-${var.environment}"
  #   enabled = true
  # }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# ── Target Group ──────────────────────────────────────────────────────────────

resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}

# ── Registro de la EC2 en el Target Group ────────────────────────────────────

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

# ── Listener HTTP (puerto 80) ─────────────────────────────────────────────────

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-listener-http"
  }
}

##############################################################################
# NOTA: Para HTTPS agrega un aws_lb_listener en puerto 443 con protocolo HTTPS
# y un certificado ACM. Ejemplo:
#
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn   = aws_acm_certificate.cert.arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.web.arn
#   }
# }
##############################################################################

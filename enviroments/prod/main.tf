##############################################################################
# main.tf  –  Root module / Orquestador
#
# Este archivo solo instancia módulos y conecta sus outputs como inputs.
# Toda la lógica de recursos vive dentro de modules/.
##############################################################################

# ── 1. Red ────────────────────────────────────────────────────────────────────

module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ── 2. Security Groups ────────────────────────────────────────────────────────

module "security_groups" {
  source = "../../modules/security_groups"

  project_name  = var.project_name
  environment   = var.environment
  vpc_id        = module.networking.vpc_id
  key_pair_name = var.key_pair_name
}

# ── 3. EC2 ───────────────────────────────────────────────────────────────────

module "ec2" {
  source = "../../modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  subnet_id         = module.networking.private_subnet_ids[0]
  security_group_id = module.security_groups.ec2_sg_id
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  key_pair_name     = var.key_pair_name
  root_volume_size  = var.root_volume_size
}

# ── 4. ALB ───────────────────────────────────────────────────────────────────

module "alb" {
  source = "../../modules/alb"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  public_subnet_ids       = module.networking.public_subnet_ids
  security_group_id       = module.security_groups.alb_sg_id
  target_instance_id      = module.ec2.instance_id
  health_check_path       = var.health_check_path
  alb_deletion_protection = var.alb_deletion_protection
}

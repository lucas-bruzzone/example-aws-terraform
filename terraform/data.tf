# ==========================================
# DATA SOURCES
# ==========================================
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# ==========================================
# LOCALS
# ==========================================
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Tags comuns para todos os recursos
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Repository  = "terraform-bootstrap"
    AccountId   = local.account_id
    Region      = local.region
    CreatedBy   = "terraform-bootstrap"
  }

  # Nome padrão para recursos
  resource_prefix = "${var.project_name}-${var.environment}"
}
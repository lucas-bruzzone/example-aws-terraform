# ==========================================
# IAM USER ADMINISTRATIVO
# ==========================================
resource "aws_iam_user" "admin_user" {
  name = var.admin_user_name
  path = "/"

  tags = {
    Name        = var.admin_user_name
    Environment = var.environment
    Purpose     = "Terraform Administration"
  }
}

resource "aws_iam_user_policy_attachment" "admin_user_policy" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "admin_user" {
  user = aws_iam_user.admin_user.name
}

# ==========================================
# ROLE PARA GITHUB ACTIONS (OIDC)
# ==========================================
# Provider OIDC para GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Name        = "GitHub-OIDC-Provider"
    Environment = var.environment
    Purpose     = "GitHub Actions Authentication"
  }
}

# Role que o GitHub Actions pode assumir
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_org}/${var.github_repo}:*",
              "repo:${var.github_org}/*:*" # Permite qualquer repo da org/user
            ]
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-role"
    Environment = var.environment
    Purpose     = "GitHub Actions Deployment"
  }
}

# Policy para a role do GitHub Actions - ACESSO ADMINISTRATIVO COMPLETO
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
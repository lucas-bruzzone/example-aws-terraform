variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "development", "staging", "prod", "production", "devops"], var.environment)
    error_message = "Environment must be one of: dev, development, staging, prod, production, devops."
  }
}

variable "project_name" {
  description = "Project name for resource naming (must be lowercase, alphanumeric, and hyphens only)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name)) && length(var.project_name) >= 3 && length(var.project_name) <= 30
    error_message = "Project name must be 3-30 characters, lowercase, alphanumeric and hyphens only."
  }
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string

  validation {
    condition     = length(var.github_org) > 0
    error_message = "GitHub organization name cannot be empty."
  }
}

variable "github_repo" {
  description = "GitHub repository name that will assume the role"
  type        = string

  validation {
    condition     = length(var.github_repo) > 0
    error_message = "GitHub repository name cannot be empty."
  }
}

variable "admin_user_name" {
  description = "Name for the admin IAM user"
  type        = string
  default     = "terraform-admin"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.admin_user_name)) && length(var.admin_user_name) >= 1 && length(var.admin_user_name) <= 64
    error_message = "Admin user name must be 1-64 characters and contain only alphanumeric characters and +=,.@_- symbols."
  }
}
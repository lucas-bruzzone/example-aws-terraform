output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform locks"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions.arn
}

output "admin_user_name" {
  description = "Name of the admin IAM user"
  value       = aws_iam_user.admin_user.name
}

output "admin_access_key_id" {
  description = "Access Key ID for admin user"
  value       = aws_iam_access_key.admin_user.id
  sensitive   = true
}

output "admin_secret_access_key" {
  description = "Secret Access Key for admin user"
  value       = aws_iam_access_key.admin_user.secret
  sensitive   = true
}

output "terraform_backend_config" {
  description = "Terraform backend configuration"
  value = {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "terraform.tfstate"
    region         = data.aws_region.current.name
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
    encrypt        = true
  }
}
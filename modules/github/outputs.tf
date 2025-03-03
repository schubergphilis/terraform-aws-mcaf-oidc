output "iam_roles" {
  value       = module.default.iam_roles
  description = "Map GitHub OIDC IAM roles name and ARN"
}

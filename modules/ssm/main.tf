resource "aws_ssm_parameter" "db_name" {
  name        = "/symbiosis/db/name"
  type        = "SecureString"
  value       = var.db_name
  description = "RDS name for Symbiosis CRUD app"
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/symbiosis/db/host"
  type        = "SecureString"
  value       = var.db_host
  description = "RDS endpoint for Symbiosis CRUD app"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/symbiosis/db/username"
  type        = "SecureString"
  value       = var.db_username
  description = "RDS username for Symbiosis CRUD app"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/symbiosis/db/password"
  type        = "SecureString"
  value       = var.db_password
  description = "RDS password for Symbiosis CRUD app"
}
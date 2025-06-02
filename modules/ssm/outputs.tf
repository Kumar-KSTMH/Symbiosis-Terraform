output "db_host" {
  value       = aws_ssm_parameter.db_host.id
  description = "List of App Subnet IDs"
}

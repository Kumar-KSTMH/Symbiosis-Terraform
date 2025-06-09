output "db_host" {
  value       = aws_ssm_parameter.db_host.id
  description = "db host id"
}

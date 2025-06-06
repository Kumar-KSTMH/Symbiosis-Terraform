output "ebs_kms_key_arn" {
  value = aws_kms_key.ebs_kms.arn
}

output "rds_kms_key_arn" {
  value = aws_kms_key.rds_kms.arn
}
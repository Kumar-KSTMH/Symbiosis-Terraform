output "ssm_ec2_role" {
  value       = aws_iam_role.ssm_ec2_role.arn
  description = "AM Role SSM EC2 Access"
}

output "ssm_pmr_role" {
  value       = aws_iam_role.ssm_parameter_role.arn
  description = "IAM Role SSM ParameterStore Access"
}

output "ssm_instance_profile_name" {
  value = aws_iam_instance_profile.ssm_ec2_instance_profile.name
}
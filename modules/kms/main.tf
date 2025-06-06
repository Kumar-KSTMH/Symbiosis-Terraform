resource "aws_kms_key" "ebs_kms" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_key" "rds_kms" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}


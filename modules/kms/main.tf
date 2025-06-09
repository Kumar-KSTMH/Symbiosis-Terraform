resource "aws_kms_key" "ebs_kms" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "Allow root account full access",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::180294208375:root"
        },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "Allow EC2 role to use KMS key",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::180294208375:role/iam-ssm-ec2-role"
        },
        Action : [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKeyWithoutPlainText",
          "kms:ReEncrypt"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_kms_key" "rds_kms" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}


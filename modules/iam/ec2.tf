resource "aws_iam_role" "ssm_ec2_role" {
  name = "iam-ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })

  tags = {
    Name = "${var.environment}-ec2-ssm-role"
  }
}


resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_ec2_instance_profile" {
  name = "iam-ssm-ec2-instance-profile"
  role = aws_iam_role.ssm_ec2_role.name
}

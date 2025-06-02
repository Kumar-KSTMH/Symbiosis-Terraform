resource "aws_iam_role" "ssm_parameter_role" {
  name = "iam-ssm-parameter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" },
      Effect    = "Allow",
    }]
  })
}

resource "aws_iam_policy" "ssm_access" {
  name        = "SSMParameterStoreAccess"
  description = "Allow EC2 to access SSM"
  policy      = file("${path.module}/ssm-policy.json")
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ssm_parameter_role.name
  policy_arn = aws_iam_policy.ssm_access.arn
}


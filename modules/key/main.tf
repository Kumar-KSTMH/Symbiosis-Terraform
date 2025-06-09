resource "aws_key_pair" "key" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file(var.public_key_path)

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
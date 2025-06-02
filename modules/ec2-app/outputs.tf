output "app_launch_template" {
  value = {
    id             = aws_launch_template.app_lt.id
    latest_version = aws_launch_template.app_lt.latest_version
  }
}

output "web_launch_template" {
  value = {
    id             = aws_launch_template.web_lt.id
    latest_version = aws_launch_template.web_lt.latest_version
  }
}
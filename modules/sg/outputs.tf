
output "web_alb_sg" {
  value = aws_security_group.web_alb_sg.id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "app_alb_sg" {
  value = aws_security_group.app_alb_sg.id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}
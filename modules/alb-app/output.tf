output "app_alb_tg_arn" {
  value = aws_lb_target_group.app_alb_tg.arn
}

output "app_alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
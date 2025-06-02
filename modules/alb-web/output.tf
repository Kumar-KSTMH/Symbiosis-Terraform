output "web_alb_tg_arn" {
  value = aws_lb_target_group.web_alb_tg.arn
}

output "web_alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}


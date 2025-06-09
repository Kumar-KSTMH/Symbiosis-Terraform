# A Web ALB Internet-Facing

resource "aws_lb" "web_alb" {
  name                       = "symbiosis-web-alb"
  load_balancer_type         = "application"
  internal                   = false
  subnets                    = [var.web_subnet_1a_id, var.web_subnet_1b_id]
  security_groups            = [var.web_alb_sg]
  enable_deletion_protection = false

  tags = {
    Name        = "symbiosis-web-alb"
    Environment = var.environment
    Project     = var.project_name
  }

}


resource "aws_lb_target_group" "web_alb_tg" {
  vpc_id      = var.vpc_id
  name        = "web-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    path                = "/"
    enabled             = true
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "symbiosis-web-alb-tg"
    Environment = var.environment
    Project     = var.project_name
  }

}

resource "aws_lb_listener" "http_web" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }

  depends_on = [aws_lb_target_group.web_alb_tg]

}

/*
resource "aws_lb_listener" "https_web" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}
*/

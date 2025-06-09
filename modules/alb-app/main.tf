# App ALB Internal

resource "aws_lb" "app_alb" {
  name                       = "symbiosis-app-alb"
  load_balancer_type         = "application"
  internal                   = true
  subnets                    = [var.app_subnet_1a_id, var.app_subnet_1b_id]
  security_groups            = [var.app_alb_sg]
  enable_deletion_protection = false

  tags = {
    Name        = "symbiosis-app-alb"
    Environment = var.environment
    Project     = var.project_name
  }

}

resource "aws_lb_target_group" "app_alb_tg" {
  name        = "app-alb-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
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
    Name        = "symbiosis-app-alb-tg"
    Environment = var.environment
    Project     = var.project_name
  }

}

resource "aws_lb_listener" "http_app" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_tg.arn
  }

  depends_on = [aws_lb_target_group.app_alb_tg]

}


# A Web ALB Internet-Facing

resource "aws_lb" "web_alb" {
  name               = "symbiosis-web-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = [var.web_subnet_1a_id, var.web_subnet_1b_id]
  security_groups    = [var.web_alb_sg]

  tags = {
    Name = "symbiosis-web-alb"
  }
}

resource "aws_lb_target_group" "web_alb_tg" {
  vpc_id   = var.vpc_id
  name     = "web-alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
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

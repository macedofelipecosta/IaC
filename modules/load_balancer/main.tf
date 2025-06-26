resource "aws_alb" "app_alb" {
  name            = "main-voting-alb"
  internal        = false
  subnets         = var.public_subnets_id
  idle_timeout    = 4000
  security_groups = [var.app_sg_id]
}


resource "aws_alb_target_group" "alb_vote_tg" {
  name        = "vote-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "45"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "4"
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_alb_target_group" "alb_result_tg" {
  name        = "result-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "45"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "4"
  }
}

resource "aws_alb_listener_rule" "vote_rule" {
  listener_arn = aws_alb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_vote_tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_alb_listener_rule" "result_rule" {
  listener_arn = aws_alb_listener.http_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_result_tg.arn
  }

  condition {
    path_pattern {
      values = ["/result*"]
    }
  }
}





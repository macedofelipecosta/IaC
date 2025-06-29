resource "aws_alb" "app_alb" {
  name            = "main-voting-alb"
  internal        = false
  subnets         = var.public_subnets_id
  idle_timeout    = 4000
  security_groups = [var.app_sg_id]
}

resource "aws_alb" "result_alb" {
  name            = "result-voting-alb"
  internal        = false
  subnets         = var.public_subnets_id
  security_groups = [var.app_sg_id]  # puede ser el mismo SG o uno separado
}


resource "aws_alb_target_group" "alb_vote_tg" {
  name        = "vote-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "4"
  }
}

resource "aws_alb_listener" "vote_listener" {
  load_balancer_arn = aws_alb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_vote_tg.arn
  }

}

resource "aws_alb_listener" "result_listener" {
  load_balancer_arn = aws_alb.result_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_result_tg.arn
  }
}


resource "aws_alb_target_group" "alb_result_tg" {
  name        = "result-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    protocol            = "HTTP"
    matcher             = "200-404"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "4"
  }
}






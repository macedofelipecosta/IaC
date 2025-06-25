resource "aws_alb" "alb_vote" {
  name            = "alb_vote"
  internal        = false
  subnets         = [for s in var.private_subnets_id : s]
  idle_timeout    = 4000
  security_groups = [var.app_sg_id]
}

resource "aws_alb" "alb_result" {
  name            = "alb_result"
  internal        = false
  subnets         = [for s in var.private_subnets_id : s]
  idle_timeout    = 4000
  security_groups = [var.app_sg_id]
}

resource "aws_alb_target_group" "alb_vote_tg" {
  name        = "alb_vote_tg"
  port        = "5000"
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

resource "aws_alb_listener" "alb_vote_listener" {
  load_balancer_arn = aws_alb.alb_vote.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.alb_vote_tg.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_result_tg" {
  name        = "alb_result_tg"
  port        = "5001"
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

resource "aws_alb_listener" "alb_result_listener" {
  load_balancer_arn = aws_alb.alb_result.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.alb_result_tg.id
    type             = "forward"
  }
}
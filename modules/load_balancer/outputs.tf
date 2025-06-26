output "alb_app_dns"{
    description = "Devuelve la direccion url por donde se accede a la app vote o result "
    value= aws_alb.app_alb.dns_name
}

output "target_group_arn_vote" {
  description = "devuelve el arn del tg vote"
  value= aws_alb_target_group.alb_vote_tg.arn
}

output "target_group_arn_result" {
  description = "devuelve el arn del tg result"
  value= aws_alb_target_group.alb_result_tg.arn
}

output "aws_listener_http" {
  description = "devuelve el arn del listener http"
  value= aws_alb_listener.http_listener.arn
  
}

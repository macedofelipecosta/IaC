output "alb_vote_dns"{
    description = "Devuelve la direccion url por donde se accede a la app vote"
    value= aws_alb.alb_vote.name
}
output "alb_result_dns" {
  description = "Devuelve la direccion url por donde se accede a la app result"
  value = aws_alb.alb_result.name
}

output "target_group_arn_vote" {
  description = "devuelve el arn del tg vote"
  value= aws_alb_target_group.alb_vote_tg.arn
}

output "target_group_arn_result" {
  description = "devuelve el arn del tg result"
  value= aws_alb_target_group.alb_result_tg.arn
}

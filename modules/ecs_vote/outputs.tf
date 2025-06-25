output "ecs_service_vote_id" {
  value = aws_ecs_service.ecs_service_vote.id
}
output "ecs_service_vote_name" {
  value = aws_ecs_service.ecs_service_vote.name
}
output "ecs_task_def_vote_id" {
  value = aws_ecs_task_definition.task_def_vote.id
}
output "ecs_log_vote" {
  value = "aws logs tail /ecs/vote --follow --region ${var.region}"
}
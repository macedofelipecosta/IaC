output "ecs_service_result_id" {
  value = aws_ecs_service.ecs_service_result.id
}
output "ecs_service_result_name" {
  value = aws_ecs_service.ecs_service_result.name
}
output "ecs_task_def_result_id" {
  value = aws_ecs_task_definition.task_def_result.id
}
output "ecs_log_result" {
  value = "aws logs tail /ecs/result --follow --region ${var.region}"
}

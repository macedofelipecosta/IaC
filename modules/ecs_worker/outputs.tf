output "ecs_service_worker_id" {
  value = aws_ecs_service.ecs_service_worker.id
}
output "ecs_service_worker_name" {
  value = aws_ecs_service.ecs_service_worker.name
}
output "ecs_task_def_worker_id" {
  value = aws_ecs_task_definition.task_def_worker.id
}
output "ecs_log_worker" {
  value = "aws logs tail /ecs/worker --follow --region ${var.region}"
}
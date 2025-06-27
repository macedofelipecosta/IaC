output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.voting.id
}

output "redis_service_id" {
  value = aws_service_discovery_service.redis.arn
}

output "db_service_id" {
  value = aws_service_discovery_service.db.arn
}
output "worker_service_registry_arn" {
  value = aws_service_discovery_service.worker.arn
}
output "redis_endpoint" {
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
  description = "DNS endpoint of the Redis primary node"
}

output "redis_port" {
  value       = aws_elasticache_replication_group.this.port
  description = "Port number for Redis (usually 6379)"
}

output "redis_cluster_id" {
  value       = aws_elasticache_replication_group.this.id
  description = "ID of the Redis cluster"
}
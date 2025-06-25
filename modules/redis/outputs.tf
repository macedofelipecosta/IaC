output "redis_cluster_id" {
  value = aws_elasticache_cluster.aws_redis.id
}
output "redis_subnet_group_name" {
  value = aws_elasticache_subnet_group.cache_subnet_group.name
}
output "redis_parameter_group_name" {
  value = aws_elasticache_parameter_group.default.name
}
output "url_redis" {
  value = aws_elasticache_cluster.aws_redis.configuration_endpoint[0].address
  
}
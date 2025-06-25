resource "aws_elasticache_cluster" "aws_redis" {
  cluster_id               = "cluster_redis"
  engine                   = "redis"
  node_type                = "cache.t3.micro"
  num_cache_nodes          = 1
  engine_version           = "5.0.0"
  port                     = 6379
  apply_immediately        = true
  security_group_ids       = [var.databases_sg]
  parameter_group_name     = aws_elasticache_parameter_group.default.name
  subnet_group_name        = aws_elasticache_subnet_group.cache_subnet_group.name

}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "${var.environment}-cache-subnet"
  subnet_ids = [for s in var.private_subnet_ids : s]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "default.redis5.0"
  family = "redis5.0"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }
}
resource "aws_elasticache_cluster" "aws_redis" {
  cluster_id               = "cluster-redis"
  engine                   = "redis"
  node_type                = "cache.t3.micro"
  num_cache_nodes          = 1
  engine_version           = "6.2"
  port                     = 6379
  apply_immediately        = true
  security_group_ids       = [var.databases_sg]
  parameter_group_name     = aws_elasticache_parameter_group.default.name
  subnet_group_name        = aws_elasticache_subnet_group.cache_subnet_group.name

}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "redis-cache-subnet"
  subnet_ids = [for s in var.private_subnet_ids : s]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "redis6"
  family = "redis6.x"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }
}
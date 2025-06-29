resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
  description                = "Cluster Redis para ${var.environment}"
  replication_group_id       = "${var.environment}-redis"
  node_type                  = var.node_type
  engine                     = "redis"
  engine_version             = var.engine_version
  automatic_failover_enabled = false
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [var.redis_sg_id, var.app_sg_id]

  tags = {
    Environment = var.environment
    Project     = "voting-app"
  }
}

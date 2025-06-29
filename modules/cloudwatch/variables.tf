variable "dashboard_name" {
  type        = string
  description = "Nombre del dashboard de CloudWatch"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Nombre del cluster ECS"
}

variable "rds_instance_id" {
  type        = string
  description = "ID de la instancia RDS PostgreSQL"
}

variable "redis_cluster_id" {
  type        = string
  description = "ID del cluster de Redis (ElastiCache)"
}

variable "alb_name" {
  type        = string
  description = "Nombre del ALB en formato arn:aws:elasticloadbalancing:region:xxx:loadbalancer/app/..."
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Región AWS"
}

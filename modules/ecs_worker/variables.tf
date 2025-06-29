variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}
variable "app_sg" {
  description = "Id de app_sg"
  type        = string
}
variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}
variable "private_subnets_id" {
  description = "Private subnets IDs"
  type        = list(string)
}
variable "role_arn" {
  description = "IAM role ARN"
  type        = string
  default     = "LabRole"
}
variable "worker_image" {
  description = "URL de la imagen Docker worker"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "aws_region" {
  description = "AWS region for logging"
  type        = string
  default     = "us-east-1"
}
variable "redis_endpoint" {
  description = "Redis endpoint"
  type        = string
}
variable "postgres_endpoint" {
  description = "Postgres endpoint"
  type        = string
}
variable "postgres_db_name" {
  description = "Postgres database name"
  type        = string
}
variable "postgres_port" {
  description = "Postgres port"
  type        = string
  default     = "5432"
}
variable "redis_port" {
  description = "Redis port"
  type        = string
  default     = "6379"
}
variable "rds_sg" {
  description = "RDS security group ID"
  type        = string
}

variable "redis_sg" {
  description = "Redis security group ID"
  type        = string
}
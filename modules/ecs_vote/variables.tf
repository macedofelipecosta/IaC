variable "vote_image" {
  description = "URL de la imagen Docker vote"
  type        = string
}
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
variable "private_subnet_ids" {
  description = "Private subnets IDs"
  type        = list(string)
}
variable "target_group_arn_vote" {
  description = "Target group ARN para el servicio de vote"
  type        = string
}
variable "role_arn" {
  description = "IAM role ARN"
  type        = string
  default     = "LabRole"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "url_elasticache_redis" {
  description = "URL del servicio de Redis en ElastiCache"
  type        = string
}
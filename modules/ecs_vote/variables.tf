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
variable "private_subnets_id" {
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
variable "aws_region" {
  description = "AWS region for logging"
  type        = string
  default     = "us-east-1"
}

variable "redis_endpoint" {
  description = "Redis endpoint"
  type        = string
}
variable "redis_port" {
  description = "Redis port"
  type        = string
  default     = "6379"
}

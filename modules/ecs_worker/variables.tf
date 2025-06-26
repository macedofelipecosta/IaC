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
variable "db_endpoint" {
  description = "Endpoint de la base de datos"
  type        = string
}
variable "redis_endpoint" {
  description = "Endpoint de Redis"
  type        = string
}
variable "service_discovery_arn" {
  description = "ARN del servicio de descubrimiento"
  type        = string
  
}
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
variable "worker_service_registry_arn" {
  description = "ARN del servicio de registro para el worker"
  type        = string  
}
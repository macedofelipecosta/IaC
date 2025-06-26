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

variable "target_group_arn_result" {
  description = "Target group ARN para el servicio de result"
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
variable "result_image" {
  description = "URL de la imagen Docker result"
  type        = string
}

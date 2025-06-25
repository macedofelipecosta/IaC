variable "environment" {
  description = "Ambiente de despliegue, por ejemplo: dev, staging, prod"
  type        = string
}

variable "vpc_cidr_block" {
  description = "El bloque CIDR para la VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "Los bloques CIDR para las subredes publicas"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "Los bloques CIDR para las subredes privadas"
  type        = list(string)
}

variable "vpc_name" {
  description = "El nombre de la VPC"
  type        = string
}

variable "azs" {
  description = "Las zonas de disponibilidad para la VPC"
  type        = list(string)
}

variable "vote_image" {
  description = "La imagen del contenedor para la aplicacion de votacion"
  type        = string
}
variable "result_image" {
  description = "La imagen del contenedor para la aplicacion de resultados"
  type        = string
}
variable "worker_image" {
  description = "La imagen del contenedor para la aplicacion de worker"
  type        = string
}
variable "aws_region" {
  description = "La region de AWS donde se desplegara la infraestructura"
  type        = string
}
variable "cluster_name" {
  description = "El nombre del cluster de ECS"
  type        = string
}

variable "capacity_providers" {
  description = "Lista de proveedores de capacidad para el cluster ECS"
  type        = list(string)
}
variable "aws_profile" {
  description = "El perfil de AWS a utilizar"
  type        = string
  default     = "default"
}
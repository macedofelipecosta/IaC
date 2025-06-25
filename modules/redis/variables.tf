variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}
variable "databases_sg" {
  description = "Id de databases_sg"
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnets IDs"
  type        = list(string)
}
variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}
variable "databases_sg" {
  description = "ID del grupo de seguridad para las bases de datos"
  type        = string
}
variable "private_subnet_ids" {
  description = "Lista de IDs de subredes privadas"
  type        = list(string)
}
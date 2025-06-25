variable cluster_name {
  description = "Nombre del cluster de ECS"
  type        = string
}

variable environment {
  description = "Entorno de despliegue"
  type        = string
}
variable capacity_providers {
  description = "Lista de proveedores de capacidad para el cluster ECS"
  type        = list(string)
}

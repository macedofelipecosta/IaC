variable "app_sg_id"{
    description = "Id del app_sg"
    type = string
}

variable "vpc_id"{
    description = "Id de la vpc donde se despliega el recurso"
    type = string
}

variable "private_subnets_id"{
    description = "Id de las subnets privadas"
    type = list(string)
}
variable "public_subnets_id"{
    description = "Id de las subnets publicas"
    type = list(string)
}
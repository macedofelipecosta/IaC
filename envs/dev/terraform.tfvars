#Configuracion de variables para el entorno de desarrollo
environment = "dev"
aws_region = "us-east-1"
vpc_name = "votingApp-vpc-dev"


#Variables para el modulo Network
vpc_cidr_block  = "10.0.0.0/16"
#public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidr_blocks  = ["10.0.2.0/24"]
private_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24"]
azs             = ["us-east-1a", "us-east-1b"]


#Variables para el modulo Security Groups

#Variables para el Cluster ECS
cluster_name   = "votingApp-cluster-dev"

#Imagenes de contenedor
vote_image = "fmacedocosta/vote-app:latest"
result_image = "fmacedocosta/result-app:latest"
worker_image = "fmacedocosta/worker-app:latest"

capacity_providers = [ "FARGATE", "FARGATE_SPOT" ]


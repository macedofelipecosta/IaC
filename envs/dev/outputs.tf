
output "alb_vote_dns" {
  description = "DNS del Application Load Balancer"
  value       = module.load_balancer.alb_app_dns
}
output "alb_result_dns" {
  description = "DNS del Application Load Balancer para la app Result"
  value       = module.load_balancer.alb_result_dns
}

output "alb_target_group_arn_vote" {
  description = "ARN del Target Group vote asociado al ALB"
  value       = module.load_balancer.target_group_arn_vote

}
output "alb_target_group_arn_result" {
  description = "ARN del Target Group result asociado al ALB"
  value       = module.load_balancer.target_group_arn_result

}

output "ecs_service_vote_name" {
  description = "Nombre del servicio ECS Fargate del modulo Vote"
  value       = module.ecs_vote.ecs_service_vote_name
}

output "ecs_service_result_name" {
  description = "Nombre del servicio ECS Fargate del modulo Result"
  value       = module.ecs_result.ecs_service_result_name
}

output "ecs_service_worker_name" {
  description = "Nombre del servicio ECS Fargate del modulo Worker"
  value       = module.ecs_worker.ecs_service_worker_name
}


#Se retorna un unico ID de cluster ECS, ya que todos los servicios comparten el mismo cluster
output "ecs_cluster_id" {
  description = "ID del cluster ECS"
  value       = module.cluster.cluster_id
}

output "vpc_id" {
  description = "ID de la VPC usada"
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "IDs de las subnets privadas usadas por ECS"
  value       = module.network.private_subnet_ids
}

output "dashboard_url" {
  value = module.cloudwatch.dashboard_url
}

output "db_name" {
  description = "Nombre de la base de datos RDS"
  value       = module.rds_postgres.postgres_db_name
}

output "postgres_endpoint" {
  value       = module.rds_postgres.postgres_endpoint
  description = "Endpoint de la instancia RDS PostgreSQL"
  
}
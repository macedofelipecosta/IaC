
output "alb_dns_result" {
  description = "DNS del Application Load Balancer"
  value       = module.load_balancer.alb_result_dns
}

output "alb_dns_vote" {
  description = "DNS del Application Load Balancer"
  value       = module.load_balancer.alb_vote_dns
  
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


output "cluster_id" {
  description = "Id del cluster de ECS"
  value       = aws_ecs_cluster.vote_cluster.id
}
output "cluster_name" {
  description = "Nombre del cluster de ECS"
  value       = aws_ecs_cluster.vote_cluster.name
}
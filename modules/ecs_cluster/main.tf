resource "aws_ecs_cluster" "vote_cluster" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name
    environment = var.environment
  }  
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.vote_cluster.name
  
  capacity_providers = var.capacity_providers

    default_capacity_provider_strategy {
        capacity_provider = "FARGATE"
        base = 3
        weight            = 1
    }

    default_capacity_provider_strategy {
        capacity_provider = "FARGATE_SPOT"
        base = 0
        weight            = 1
    }
}
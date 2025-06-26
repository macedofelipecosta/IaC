resource "aws_ecs_task_definition" "redis" {
  family                   = "redis-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "redis"
      image     = var.redis_image
      portMappings = [{
        containerPort = 6379
        protocol      = "tcp"
      }]
    }
  ])
}


resource "aws_ecs_service" "redis" {
  name            = "redis"
  cluster         = var.cluster_arn
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.redis.arn

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn   = var.redis_service_arn
    container_name = "redis"
    container_port = 6379
  }
}

resource "aws_ecs_task_definition" "postgres" {
  family                   = "postgres-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "db"
      image     = var.postgres_image
      portMappings = [{
        containerPort = 5432
        protocol      = "tcp"
      }]
      environment = [
        { name = "POSTGRES_USER", value = "votingapp_admin" },
        { name = "POSTGRES_PASSWORD", value = "password" },
        { name = "POSTGRES_DB", value = "postgres" }
      ]
    }
  ])
}


resource "aws_ecs_service" "postgres" {
  name            = "db"
  cluster         = var.cluster_arn
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.postgres.arn

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn   = var.db_service_arn
    container_name = "db"
    container_port = 5432
  }
}

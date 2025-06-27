resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/worker"
  retention_in_days = 3
}

resource "aws_ecs_service" "ecs_service_worker" {
  name                   = "worker"
  task_definition        = aws_ecs_task_definition.task_def_worker.arn
  cluster                = var.cluster_id
  desired_count          = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 3
    base              = 3

  }

  network_configuration {
    subnets          = [for s in var.private_subnets_id : s]
    security_groups  = [var.app_sg]
    assign_public_ip = false
  }

    service_registries {
    registry_arn   = var.worker_service_registry_arn
    container_name = "worker_app"
  }
}

resource "aws_ecs_task_definition" "task_def_worker" {
  family                   = "${var.environment}_worker_task"
  execution_role_arn       = var.role_arn
  task_role_arn            = var.role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      "name" : "worker_app",
      "image" : var.worker_image,
      "cpu" : 256,
      "memory" : 512,
      "interactive" : true,
      "pseudoTerminal" : true,
      "mountPoints" : [],
      "environment" : [
        { "name" = "DB_HOST", "value" = "db.votingapp.local" },
        { "name" = "DB_USER", "value" = "postgres" },
        { "name" = "DB_PASSWORD", "value" = "postgres" },
        { "name" = "DB_NAME", "value" = "postgres" },
        { "name" = "REDIS_HOST", "value" = "redis.votingapp.local" },
        { "name" = "DB_PORT", "value" = "5432" },
        { "name" = "REDIS_PORT", "value" = "6379" }

      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "secretOptions" : null,
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.this.name}",
          "awslogs-stream-prefix" : "worker",
          "awslogs-region" : var.aws_region
        }
      }
    }
  ])
}

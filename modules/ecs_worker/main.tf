resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/worker"
  retention_in_days = 3
}

resource "aws_ecs_service" "ecs_service_worker" {
  name                   = "ecs_service_worker"
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
    subnets          = [for s in var.private_subnet_ids : s]
    security_groups  = [var.app_sg]
    assign_public_ip = true
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
      "networkMode" : "awsvpc",
      "interactive" : true,
      "pseudoTerminal" : true,
      "mountPoints" : [],
      environment = [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_USER"
          value = "votingapp_admin"
        },
        {
          name  = "DB_PASSWORD"
          value = "password"
        },
        {
          name  = "DB_NAME"
          value = "postgres"
        },
        {
          name  = "REDIS_HOST"
          value = var.redis_endpoint
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        },
        {
          name  = "AWS_REGION"
          value = "us-east-1"
        }
      ]

      "logConfiguration" : {
        "logDriver" : "awslogs",
        "secretOptions" : null,
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.this.name}",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "worker"
        }
      }
    }
  ])
}

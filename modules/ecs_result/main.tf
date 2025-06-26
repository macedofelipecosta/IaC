resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/result"
  retention_in_days = 3
}

resource "aws_ecs_service" "ecs_service_result" {
  name                   = "result"
  task_definition        = aws_ecs_task_definition.task_def_result.arn
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

  load_balancer {
    target_group_arn = var.target_group_arn_result
    container_name   = "result_app"
    container_port   = "80"
  }
  tags = {
    Name        = "ecs_service_result"
    environment = var.environment
  }
}

resource "aws_ecs_task_definition" "task_def_result" {
  family                   = "${var.environment}_result_task"
  execution_role_arn       = var.role_arn
  task_role_arn            = var.role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      # amazonq-ignore-next-line
      "name" : "result_app",
      "image" : var.result_image,
      "cpu" : 256,
      "memory" : 512,
      "networkMode" : "awsvpc",
      "interactive" : true,
      "pseudoTerminal" : true,
      "mountPoints" : [],
      "environment" : [
        {
          "name" : "DB_HOST",
          "value" : "db"
        },
        {
          "name" : "DB_PORT",
          "value" : "5432"
        },
        {
          # amazonq-ignore-next-line
          "name" : "DB_USER",
          "value" : "votingapp_admin"
        },
        {
          "name" : "DB_PASSWORD",
          "value" : "password"
        },
        {
          "name" : "DB_NAME",
          "value" : "postgres"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "secretOptions" : null,
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.this.name}",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "result"
        }
      },
      "portMappings" : [{
        "containerPort" : 80,
        "hostPort" : 80,
        "protocol" : "tcp"
        },
        {
          "containerPort" : 5858,
          "hostPort" : 5858
      }]
    }
  ])
}

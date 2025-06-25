resource "aes_cloudwatch_log_group" "this" {
  name              = "/ecs/vote"
  retention_in_days = 3
}

resource "aws_ecs_service" "ecs_service_vote" {
  name                   = "ecs_service_vote"
  task_definition        = aws_ecs_task_definition.task_def_vote.arn
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

  load_balancer {
    target_group_arn = var.target_group_arn_vote
    container_name   = "vote_app"
    container_port   = "5000"
  }
}

resource "aws_ecs_task_definition" "task_def_vote" {
  family                   = "${var.environment}_vote_task"
  execution_role_arn       = var.role_arn
  task_role_arn            = var.role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsondecode(
    [
      {
        "name" : "vote_app",
        "image" : var.vote_image,
        "cpu" : "256",
        "memory" : "512",
        "networkMode" : "awsvpc",
        "interactive" : true,
        "pseudoTerminal" : true,
        "mountPoints" : [],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "secretOptions" : null,
          "options" : {
            "awslogs-group" : "${aes_cloudwatch_log_group.this.name}",
            "awslogs-region" : "us-east-1",
            "awslogs-stream-prefix" : "vote"
          }
        },
        "portMappings" : [{
          "containerPort" : 5000,
          "hostPort" : 5000
        }]
      }
  ])
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/vote"
  retention_in_days = 3
}

resource "aws_ecs_service" "ecs_service_vote" {
  name                   = "vote"
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
    subnets          = [for s in var.private_subnets_id : s]
    security_groups  = [var.app_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn_vote
    container_name   = "vote_app"
    container_port   = "80"
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
  container_definitions = jsonencode(
    [
      {
        "name" : "vote_app",
        "image" : var.vote_image,
        "cpu" : 256,
        "memory" : 512,
        "interactive" : true,
        "pseudoTerminal" : true,
        "mountPoints" : [],
        "portMappings" : [{
          "containerPort" : 80,
          "protocol" : "tcp"
        }],
        "environment" : [
          {
            "name" : "OPTION_A",
            "value" : "Cats"
          },
          {
            "name" : "OPTION_B",
            "value" : "Dogs"
          },
          {
            "name" : "REDIS_HOST",
            "value" : var.redis_endpoint
          },
          {
            "name" : "REDIS_PORT",
            "value" : var.redis_port
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "secretOptions" : null,
          "options" : {
            "awslogs-group" : "${aws_cloudwatch_log_group.this.name}",
            "awslogs-region" : var.aws_region,
            "awslogs-stream-prefix" : "vote"
          }
        }
      }
  ])

}

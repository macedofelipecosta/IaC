resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          title = "CPU Utilization - ECS Vote",
          metrics = [[ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "vote" ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 12, y = 0, width = 12, height = 6,
        properties = {
          title = "Memory Utilization - ECS Vote",
          metrics = [[ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "vote" ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 0, y = 6, width = 12, height = 6,
        properties = {
          title = "Latency - ALB",
          metrics = [[ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_vote_name ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 0, y = 6, width = 12, height = 6,
        properties = {
          title = "Latency - ALB",
          metrics = [[ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_result_name ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 12, y = 6, width = 12, height = 6,
        properties = {
          title = "RDS PostgreSQL Connections",
          metrics = [[ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_id ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      },
      {
        type = "metric",
        x = 0, y = 12, width = 12, height = 6,
        properties = {
          title = "Redis - Current Connections",
          metrics = [[ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", var.redis_cluster_id ]],
          stat = "Average", period = 300, view = "timeSeries", region = var.aws_region
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "ecs_vote_cpu_high" {
  alarm_name          = "HighCPUUtilization-ECS-Vote"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ECS Vote task CPU utilization too high"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "vote"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "ALB-5XX-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationALB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "ALB is returning too many 5XX errors"
  dimensions = {
    LoadBalancer = var.alb_result_name
    LoadBalancerArn = var.alb_vote_name
  }
}

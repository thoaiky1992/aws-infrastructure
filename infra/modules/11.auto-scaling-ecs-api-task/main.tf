// ---------------------------------------------------------------------------------
/*
  Cấu hình tăng/giảm ec2 instance => sẽ tăng desired_count lên/giảm 1 của service tương ứng
*/
resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.ecs_cluster.api.name}/${var.ecs_api_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_api_cale_out_task" {
  name               = "${var.environment}-ecs-api-cale-out-task"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_api_cale_in_task" {
  name               = "${var.environment}-ecs-api-cale-in-task"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}

// nếu số lần lặp x thời gian = 1 x 60 = 60s > 70% CPU sẽ scale up
resource "aws_cloudwatch_metric_alarm" "ecs_api_scale_out_task_alarm" {
  alarm_name          = "${var.environment}-ecs-api-scale-out-task-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1" // số lần lặp
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60" // thời gian
  statistic           = "Average"
  threshold           = "70"

  alarm_actions = [aws_appautoscaling_policy.ecs_api_cale_out_task.arn]
  dimensions = {
    AutoScalingGroupName = var.auto_scaling_group.api.name
  }
}
resource "aws_cloudwatch_metric_alarm" "ecs_api_scale_in_task_alarm" {
  alarm_name          = "${var.environment}-ecs-api-scale-in-task-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  alarm_actions = [aws_appautoscaling_policy.ecs_api_cale_in_task.arn]
  dimensions = {
    AutoScalingGroupName = var.auto_scaling_group.api.name
  }
}

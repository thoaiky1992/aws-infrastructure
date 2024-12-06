/*
  Cấu hình auto scaling group khi CPU/RAM vượt quá mức cho phép sẽ tăng số lượng ec2 instance cần thiét
*/
resource "aws_autoscaling_group" "ecs_api_auto_scaling_group" {
  name                = "ecs_api_auto_scaling_group"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = 2
  max_size            = 10
  min_size            = 2

  launch_template {
    id      = var.launch_template.api.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_policy" "ecs_api_scale_out_ec2_istance_by_cpu" {
  name                    = "ecs-api-scale-out-ec2-istance-by-cpu"
  scaling_adjustment      = 1 // số lượng instance sẽ được thêm khi scale up thực hiện
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300 // sau khi scale up thì 300s (5 phút) tiếp theo sẽ không làm bất cứ gì
  autoscaling_group_name  = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  metric_aggregation_type = "Average"
  policy_type             = "SimpleScaling"
}

resource "aws_autoscaling_policy" "ecs_api_scale_in_ec2_istance_by_cpu" {
  name                    = "ecs-api-scale-in-ec2-istance-by-cpu"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  metric_aggregation_type = "Average"
  policy_type             = "SimpleScaling"
}

// nếu số lần lặp x thời gian = 1 x 60 = 60s > 70% CPU sẽ scale up
resource "aws_cloudwatch_metric_alarm" "ecs_api_high_cpu_alarm" {
  alarm_name          = "ecs-api-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1" // số lần lặp
  metric_name         = "CPUUtilization" // các metric khác: MemoryUtilization, ....
  namespace           = "AWS/EC2"
  period              = "60" // thời gian
  statistic           = "Average"
  threshold           = "70"

  alarm_actions = [aws_autoscaling_policy.ecs_api_scale_out_ec2_istance_by_cpu.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_api_low_cpu_alarm" {
  alarm_name          = "ecs-api-low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  alarm_actions = [aws_autoscaling_policy.ecs_api_scale_in_ec2_istance_by_cpu.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  }
}


// ----- START AUTO_SCALING_GROUP UI -----
resource "aws_autoscaling_group" "ecs_ui_auto_scaling_group" {
  name                = "ecs-ui-auto-scaling-group"
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = var.launch_template.ui.id
    version = "$Latest"
  }
}
// ----- END AUTO_SCALING_GROUP UI -----
output "api" {
  value = {
    id   = aws_autoscaling_group.ecs_api_auto_scaling_group.id
    name = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  }
}

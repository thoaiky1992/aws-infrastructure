output "api" {
  value = {
    arn = aws_ecs_task_definition.ecs_api_task_definition.arn
  }
}
output "ui" {
  value = {
    arn = aws_ecs_task_definition.ecs_ui_task_definition.arn
  }
}
output "nginx" {
  value = {
    arn = aws_ecs_task_definition.ecs_nginx_task_definition.arn
  }
}
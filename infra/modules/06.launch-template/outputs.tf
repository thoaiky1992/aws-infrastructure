output "api" {
  value = {
    id = aws_launch_template.ecs_api_launch_template.id
  }
}
output "ui" {
  value = {
    id = aws_launch_template.ecs_ui_launch_template.id
  }
}


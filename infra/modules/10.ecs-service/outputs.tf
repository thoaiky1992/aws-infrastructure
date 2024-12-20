output "api" {
  value = {
    name = aws_ecs_service.ecs_api_service.name
  }
}

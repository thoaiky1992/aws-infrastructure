output "api" {
  value = {
    id   = aws_ecs_cluster.ecs_api_cluster.id
    name = aws_ecs_cluster.ecs_api_cluster.name
  }
}
output "ui" {
  value = {
    id   = aws_ecs_cluster.ecs_ui_cluster.id
    name = aws_ecs_cluster.ecs_ui_cluster.name
  }
}

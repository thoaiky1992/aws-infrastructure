resource "aws_ecs_cluster" "ecs_api_cluster" {
  name = "${replace(var.environment, ".", "-")}-ecs-api-cluster"
}
resource "aws_ecs_cluster" "ecs_ui_cluster" {
  name = "${replace(var.environment, ".", "-")}-ecs-ui-cluster"
}

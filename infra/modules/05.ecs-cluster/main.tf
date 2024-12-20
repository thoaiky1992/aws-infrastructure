resource "aws_ecs_cluster" "ecs_api_cluster" {
  name = "ecs-api-cluster"
}
resource "aws_ecs_cluster" "ecs_ui_cluster" {
  name = "ecs-ui-cluster"
}

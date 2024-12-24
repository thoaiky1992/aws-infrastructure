resource "aws_ecs_cluster" "ecs_api_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-api-cluster"
}
resource "aws_ecs_cluster" "ecs_ui_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-ui-cluster"
}

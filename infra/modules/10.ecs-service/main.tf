resource "aws_ecs_service" "ecs_api_service" {
  name            = "${replace(var.environment, ".", "-")}-ecs-api-service"
  cluster         = var.ecs_cluster.api.id
  task_definition = var.ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  load_balancer {
    target_group_arn = var.target_group.api.arn
    container_name   = "api"
    container_port   = 4000
  }
}

resource "aws_ecs_service" "ecs_ui_service" {
  name            = "${replace(var.environment, ".", "-")}-ecs-ui-service"
  cluster         = var.ecs_cluster.ui.id
  task_definition = var.ecs_task_definition.ui.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  load_balancer {
    target_group_arn = var.target_group.ui.arn
    container_name   = "ui"
    container_port   = 3000
  }
}
resource "aws_ecs_service" "ecs_nginx_service" {
  name            = "${replace(var.environment, ".", "-")}-ecs-nginx-service"
  cluster         = var.ecs_cluster.ui.id
  task_definition = var.ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  load_balancer {
    target_group_arn = var.target_group.nginx.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
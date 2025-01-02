resource "aws_cloudwatch_log_group" "ecs_api_log_group" {
  name              = "${var.tag_version}/ecs/ecs-api-task"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_api_task_definition" {
  family             = "${replace(var.tag_version, ".", "-")}-ecs-api-task"
  network_mode       = "bridge"
  execution_role_arn = var.ecs_task_execution_role.arn
  cpu                = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "thoaiky1992/app-api:latest"
      cpu       = 256
      memory    = 512
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.tag_version}/ecs/ecs-api-task"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.tag_version
        }
      }
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 0
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "PORT"
          value = "4000"
        },
        {
          name  = "DATABASE_URL"
          value = var.database_url
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
      ]
    }
  ])
}

// ----- START UI TASK -----
resource "aws_cloudwatch_log_group" "ecs_ui_log_group" {
  name              = "${var.tag_version}/ecs/ecs-ui-task"
  retention_in_days = 7
}


resource "aws_ecs_task_definition" "ecs_ui_task_definition" {
  family             = "${replace(var.tag_version, ".", "-")}-ecs-ui-task"
  network_mode       = "bridge"
  execution_role_arn = var.ecs_task_execution_role.arn
  cpu                = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "ui"
      image     = "thoaiky1992/app-ui:latest"
      cpu       = 256
      memory    = 256
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 0
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.tag_version}/ecs/ecs-ui-task"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.tag_version
        }
      }
    },
  ])
}
resource "aws_cloudwatch_log_group" "ecs_nginx_log_group" {
  name              = "${var.tag_version}/ecs/ecs-nginx-task"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_nginx_task_definition" {
  family             = "${replace(var.tag_version, ".", "-")}-ecs-nginx-task"
  network_mode       = "bridge"
  execution_role_arn = var.ecs_task_execution_role.arn
  cpu                = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "thoaiky1992/nginx:latest"
      cpu       = 256
      memory    = 256
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "BACKEND_URL"
          value = "${var.next_public_backend_url}"
        },
        {
          name  = "UI_LOAD_BALANCER_URL"
          value = "${var.ui_load_balancer_url}"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.tag_version}/ecs/ecs-nginx-task"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.tag_version
        }
      }
    }
  ])
}
// ----- END UI TASK -----


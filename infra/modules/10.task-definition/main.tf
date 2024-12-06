

resource "aws_cloudwatch_log_group" "ecs_api_log_group" {
  name              = "/ecs/ecs-api-service"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_api_task_definition" {
  family             = "ecs-api-task"
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
          "awslogs-group"         = "/ecs/ecs-api-service"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
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
  name              = "/ecs/ecs-ui-service"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_ui_task_definition" {
  family             = "ecs-ui-task"
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
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-ui-service"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
    {
      name      = "nginx"
      image     = "thoaiky1992/nginx:latest"
      cpu       = 256
      memory    = 256
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "BACKEND_URL"
          value = "${var.next_public_backend_url}/api"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-ui-service"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
// ----- END UI TASK -----


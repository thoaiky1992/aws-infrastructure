output "target_group" {
  value = {
    api = {
      arn = aws_lb_target_group.ecs_api_target_group.arn
    }
    ui = {
      arn = aws_lb_target_group.ecs_ui_target_group.arn
    }
    nginx = {
      arn = aws_lb_target_group.ecs_nginx_target_group.arn
    }
  }
}
output "api" {
  value = {
    dns_name = aws_lb.ecs_api_load_balancer.dns_name
  }
}

output "ui" {
  value = {
    dns_name = aws_lb.ecs_ui_load_balancer.dns_name
  }
}


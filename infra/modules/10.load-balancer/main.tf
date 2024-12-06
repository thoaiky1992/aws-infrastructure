resource "aws_lb" "ecs_api_load_balancer" {
  name               = "ecs-api-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  tags = {
    Name = "ecs-alb"
  }
}
resource "aws_lb_target_group" "ecs_api_target_group" {
  name        = "ecs-api-target-group"
  port        = 4000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path = "/api/health-check"
  }
}

resource "aws_lb_listener" "ecs_api_alb_listener" {
  load_balancer_arn = aws_lb.ecs_api_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_api_target_group.arn
  }
}


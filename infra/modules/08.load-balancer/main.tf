# --- START LOAD BALANCER FOR API ---
resource "aws_lb" "ecs_api_load_balancer" {
  name               = "${replace(var.environment, ".", "-")}-ecs-api-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.api_security_groups
  subnets            = var.subnet_ids.private

  tags = {
    Name = "${var.environment}-ecs-api-alb"
  }
}
resource "aws_lb_target_group" "ecs_api_target_group" {
  name        = "${replace(var.environment, ".", "-")}-ecs-api-target-group"
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
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_api_target_group.arn
  }
}
# --- END LOAD BALANCER FOR API ---


# --- START LOAD BALANCER FOR UI ---
resource "aws_lb" "ecs_ui_load_balancer" {
  name               = "${replace(var.environment, ".", "-")}-ecs-ui-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.ui_security_groups
  subnets            = var.subnet_ids.public

  tags = {
    Name = "${var.environment}-ecs-ui-alb"
  }
}
resource "aws_lb_target_group" "ecs_nginx_target_group" {
  name        = "${replace(var.environment, ".", "-")}-ecs-nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}
resource "aws_lb_target_group" "ecs_ui_target_group" {
  name        = "${replace(var.environment, ".", "-")}-ecs-ui-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "ecs_nginx_alb_listener" {
  load_balancer_arn = aws_lb.ecs_ui_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_nginx_target_group.arn
  }
}

resource "aws_lb_listener" "ecs_ui_alb_listener" {
  load_balancer_arn = aws_lb.ecs_ui_load_balancer.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_ui_target_group.arn
  }
}
# --- END LOAD BALANCER FOR UI ---

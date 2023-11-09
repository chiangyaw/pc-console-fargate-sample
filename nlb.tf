resource "aws_alb" "main_nlb" {
  name            = "${var.unique_prefix}-nlb"
  load_balancer_type = "network"
  subnets         = aws_subnet.ecs_pub_sub.*.id
  security_groups = [aws_security_group.nlb_sg.id]
}

resource "aws_lb_target_group" "pc_console_tg_8083" {
  name        = "${var.unique_prefix}-tg-8083"
  port        = 8083
  protocol    = "TCP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_target_group" "pc_console_tg_8084" {
  name        = "${var.unique_prefix}-tg-8084"
  port        = 8084
  protocol    = "TCP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "TCP"
    matcher             = ""
    timeout             = "3"
    path                = ""
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "pc_console_listener_8083" {
  load_balancer_arn = aws_alb.main_nlb.id
  port              = 8083
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.pc_console_tg_8083.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "pc_console_listener_8084" {
  load_balancer_arn = aws_alb.main_nlb.id
  port              = 8084
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.pc_console_tg_8084.id
    type             = "forward"
  }
}
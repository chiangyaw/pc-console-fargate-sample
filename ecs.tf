resource "aws_ecs_cluster" "ecs_main_cluster" {
  name = "${var.unique_prefix}-ecs-cluster"
}

# data "template_file" "app_template" {
#   template = file("app.json.tpl")

#   vars = {
#     app_image      = var.app_image
#     app_port       = var.app_port
#     fargate_cpu    = var.fargate_cpu
#     fargate_memory = var.fargate_memory
#     aws_region     = var.region
#     ws_address     = var.ws_address
#     tw_image       = var.tw_image
#   }
# }

resource "aws_ecs_task_definition" "pc_console_task_def" {
  family                   = "pc-console"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = file("./twistlock-console.json")
  volume {
    name = "compute_root_volume"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.pc_console_fargate_efs.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "ecs_main_service" {
  name            = "${var.unique_prefix}-pc-console-service"
  cluster         = aws_ecs_cluster.ecs_main_cluster.id
  task_definition = aws_ecs_task_definition.pc_console_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.nlb_sg.id]
    subnets          = aws_subnet.ecs_pub_sub.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pc_console_tg_8083.id
    container_name   = "twistlock-console"
    container_port   = 8083
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pc_console_tg_8084.id
    container_name   = "twistlock-console"
    container_port   = 8084
  }

  depends_on = [aws_alb_listener.pc_console_listener_8083, aws_alb_listener.pc_console_listener_8084, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
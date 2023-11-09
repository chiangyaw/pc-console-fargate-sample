resource "aws_efs_file_system" "pc_console_fargate_efs" {
#   creation_token = "my-product"
  throughput_mode = "provisioned"
  provisioned_throughput_in_mibps = "1"
  tags = {
    Name = "${var.unique_prefix}_pc_console_fargate_efs"
  }
}

resource "aws_efs_mount_target" "pc_console_fargate_efs_mount_target" {
  count          = var.az_count
  file_system_id = aws_efs_file_system.pc_console_fargate_efs.id
  subnet_id      = element(aws_subnet.ecs_pub_sub.*.id, count.index)
  security_groups  = [aws_security_group.nlb_sg.id]

}
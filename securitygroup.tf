resource "aws_security_group" "nlb_sg" {
  name        = "${var.unique_prefix}-nlb-sg"
  description = "NLB Security Group"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 8083
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8083
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.unique_prefix}_nlb_sg"
  }
}

# resource "aws_security_group" "ecs_task_sg" {
#   name        = "${var.unique_prefix}-ecs-task-sg"
#   description = "ECS Task Security Group"
#   vpc_id      = aws_vpc.ecs_vpc.id

#   ingress {
#     from_port   = 8083
#     to_port     = 8084
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic.
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${var.unique_prefix}_ecs_task_sg"
#   }
# }
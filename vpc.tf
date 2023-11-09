resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.ecs_vpc
  enable_dns_hostnames = true
  tags = {
    Name = "${var.unique_prefix}_ecs_vpc"
  }
}
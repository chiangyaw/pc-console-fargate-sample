resource "aws_subnet" "ecs_pub_sub" {
  count             = var.az_count
  availability_zone = element(data.aws_availability_zones.azs.names, count.index + 2)
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = cidrsubnet(var.ecs_vpc, 8, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.unique_prefix}_ecs_pub_sub_${count.index + 1}"
  }
}

# resource "aws_subnet" "ecs_pri_sub" {
#   count             = var.az_count
#   availability_zone = element(data.aws_availability_zones.azs.names, count.index + 2)
#   vpc_id            = aws_vpc.ecs_vpc.id
#   cidr_block        = cidrsubnet(var.ecs_vpc, 8, count.index+10)
#   map_public_ip_on_launch = "true"
#   tags = {
#     Name = "${var.unique_prefix}_ecs_pub_sub_${count.index + 1}"
#   }
# }
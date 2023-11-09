resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "${var.unique_prefix}_ecs_igw"
  }
}

resource "aws_eip" "nat_gw_eip" {
  count         = var.az_count
  domain        = "vpc"
}


resource "aws_nat_gateway" "ecs_nat_gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.ecs_pub_sub.*.id, count.index)
  allocation_id = element(aws_eip.nat_gw_eip.*.id, count.index)
}

resource "aws_route_table" "ecs_pub_rt" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
  tags = {
    Name = "${var.unique_prefix}_ecs_rt"
  }
}

resource "aws_route_table" "ecs_pri_rt" {
  count = var.az_count
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ecs_nat_gw.*.id, count.index)
  }
  tags = {
    Name = "${var.unique_prefix}_ecs_rt"
  }
}


resource "aws_route_table_association" "ecs_sub_assoc" {
  count = var.az_count
  subnet_id = element(aws_subnet.ecs_pub_sub.*.id,count.index)
  route_table_id = aws_route_table.ecs_pub_rt.id
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.ecs_pri_sub.*.id, count.index)
  route_table_id = element(aws_route_table.ecs_pri_rt.*.id, count.index)
}
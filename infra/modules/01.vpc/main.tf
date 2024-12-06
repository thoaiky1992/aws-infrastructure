resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}
resource "aws_subnet" "subnets" {
  for_each                = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_route_table" "public_router_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-router-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_router_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets["public_subnet_1"].id
  tags = {
    Name = "main-nat-gateway"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_route_table" "private_router_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-router-table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_router_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_associations" {
  for_each       = { for subnet in var.subnets : subnet.name => subnet if subnet.map_public_ip_on_launch }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public_router_table.id

}

resource "aws_route_table_association" "private_associations" {
  for_each       = { for subnet in var.subnets : subnet.name => subnet if !subnet.map_public_ip_on_launch }
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private_router_table.id
}





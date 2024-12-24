resource "aws_subnet" "subnets" {
  for_each                = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = "${var.tag_version}-${each.value.name}"
  }
}

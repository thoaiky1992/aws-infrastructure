
resource "aws_eip" "nat_eip" {
  count  = var.nat_count
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count = var.nat_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags = {
    Name = "main-nat-gateway-${count.index}"
  }
}

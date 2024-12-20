resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}
module "subnets" {
  source = "./01.1.subnet"
  vpc_id = aws_vpc.main.id
}


module "igw" {
  source = "./01.2.igw"
  vpc_id = aws_vpc.main.id
}

module "nat" {
  source            = "./01.3.nat"
  vpc_id            = aws_vpc.main.id
  nat_count         = 2
  public_subnet_ids = module.subnets.subnet_ids.public
}

module "route_table" {
  source                    = "./01.4.route-table"
  vpc_id                    = aws_vpc.main.id
  igw_id                    = module.igw.id
  private_route_table_count = 2
  subnet_ids                = module.subnets.subnet_ids
  nat_ids                   = module.nat.ids
}

module "network-acls" {
  source             = "./01.5.network-ACLs"
  private_subnet_ids = module.subnets.subnet_ids.public
  public_subnet_ids  = module.subnets.subnet_ids.private
  vpc_id             = aws_vpc.main.id
}
module "security_group" {
  source = "./01.6.security-group"
  vpc_id = aws_vpc.main.id
}










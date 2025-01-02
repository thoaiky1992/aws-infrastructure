provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
  backend "s3" {
    bucket = "kysomaio-terraform-state" # Tên bucket đã tạo
    key    = "common/terraform.tfstate" # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}


module "vpc" {
  source      = "./00.vpc"
  environment = var.environment
}

module "iam_role" {
  source      = "./01.iam-role"
  environment = var.environment
}

module "subnets" {
  source      = "./02.subnet"
  vpc_id      = module.vpc.id
  environment = var.environment
}

module "igw" {
  source      = "./03.igw"
  vpc_id      = module.vpc.id
  environment = var.environment
}

module "nat" {
  source            = "./04.nat"
  vpc_id            = module.vpc.id
  nat_count         = 2
  public_subnet_ids = module.subnets.subnet_ids.public
  environment       = var.environment
}

module "route_table" {
  source                    = "./05.route-table"
  vpc_id                    = module.vpc.id
  igw_id                    = module.igw.id
  private_route_table_count = 2
  subnet_ids                = module.subnets.subnet_ids
  nat_ids                   = module.nat.ids
  environment               = var.environment
}

module "network-acls" {
  source             = "./06.network-acls"
  private_subnet_ids = module.subnets.subnet_ids.public
  public_subnet_ids  = module.subnets.subnet_ids.private
  vpc_id             = module.vpc.id
  environment        = var.environment
}

module "security_group" {
  source      = "./07.security-group"
  vpc_id      = module.vpc.id
  environment = var.environment
}

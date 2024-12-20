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
    bucket = "kysomaio-terraform-state"  # Tên bucket đã tạo
    key    = "v.1.0.0/terraform.tfstate" # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.dev_key.public_key_openssh
  provisioner "local-exec" {
    command = <<-EOT
      rm -rf ${var.key_pair_name}.pem
      echo "${tls_private_key.dev_key.private_key_pem}" > "${var.key_pair_name}".pem
      chmod 400 "${var.key_pair_name}".pem
    EOT
  }

}
module "vpc" {
  source      = "./modules/01.vpc"
  environment = var.environment
}

module "iam_role" {
  source      = "./modules/02.iam-role"
  environment = var.environment
}

module "bastion_host" {
  source            = "./modules/03.bastion-host"
  key_name          = var.key_pair_name
  security_group_id = module.vpc.security_groups["bastion-host-security-group"].id
  subnet_id         = module.vpc.subnet_ids.public[0]
  environment       = var.environment
}
module "database" {
  source            = "./modules/04.database"
  subnet_ids        = module.vpc.subnet_ids.private
  security_group_id = module.vpc.security_groups["postgres-security-group"].id
  database_configs  = var.database
  environment       = var.environment
}
module "ecs_cluster" {
  source      = "./modules/05.ecs-cluster"
  environment = var.environment
}
module "ecs_launch_template" {
  source = "./modules/06.launch-template"
  ami_id = var.ecs_launch_template_ami_id
  security_groups = {
    api = { id = module.vpc.security_groups["api-security-group"].id }
    ui  = { id = module.vpc.security_groups["ui-security-group"].id }
  }
  ecs_cluster                    = module.ecs_cluster
  ecs_instance_role_profile_name = module.iam_role.ecs_instance_role.profile_name
  key_pair_name                  = var.key_pair_name
  environment                    = var.environment
}
module "auto_scaling_group" {
  source             = "./modules/07.auto-scaling-group"
  public_subnet_ids  = module.vpc.subnet_ids.public
  private_subnet_ids = module.vpc.subnet_ids.private
  launch_template    = module.ecs_launch_template
  environment        = var.environment
}
module "load_balancer" {
  source              = "./modules/08.load-balancer"
  api_security_groups = [module.vpc.security_groups["api-security-group"].id]
  ui_security_groups  = [module.vpc.security_groups["ui-security-group"].id]
  subnet_ids          = module.vpc.subnet_ids
  vpc_id              = module.vpc.vpc_id
  environment         = var.environment
}

module "ecs_task_definition" {
  source                  = "./modules/09.task-definition"
  ecs_task_execution_role = module.iam_role.ecs_task_execution_role
  region                  = var.region
  database_url            = "postgresql://${var.database.username}:${var.database.password}@${module.database.address}:${var.database.port}/${var.database.name}?schema=public"
  next_public_backend_url = "${module.load_balancer.api.dns_name}:4000/api"
  depends_on              = [module.database]
  ui_load_balancer_url    = "${module.load_balancer.ui.dns_name}:3000"
  environment             = var.environment
}
module "ecs_service" {
  source              = "./modules/10.ecs-service"
  ecs_cluster         = module.ecs_cluster
  ecs_task_definition = module.ecs_task_definition
  target_group        = module.load_balancer.target_group
  environment         = var.environment
}
module "auto_scaling_ecs_api_task" {
  source               = "./modules/11.auto-scaling-ecs-api-task"
  ecs_api_service_name = module.ecs_service.api.name
  ecs_cluster          = module.ecs_cluster
  auto_scaling_group   = module.auto_scaling_group
  environment          = var.environment

  depends_on = [module.ecs_service]
}

data "aws_instances" "api_instances" {
  filter {
    name   = "tag:Name"
    values = ["ecs-api-instance"]
  }
  depends_on = [module.ecs_service]
}



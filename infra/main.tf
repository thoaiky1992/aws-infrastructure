provider "aws" {
  region = local.region
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
}
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = local.key_pair_name
  public_key = tls_private_key.dev_key.public_key_openssh
  provisioner "local-exec" {
    command = <<-EOT
      rm -rf ${local.key_pair_name}.pem
      echo "${tls_private_key.dev_key.private_key_pem}" > "${local.key_pair_name}".pem
      chmod 400 "${local.key_pair_name}".pem
    EOT
  }

}
module "vpc" {
  source = "./modules/01.vpc"
}

module "iam_role" {
  source = "./modules/02.iam-role"
}

module "bastion_host" {
  source            = "./modules/03.bastion-host"
  key_name          = local.key_pair_name
  security_group_id = module.vpc.bastion_host_security_group.id
  subnet_id         = module.vpc.subnet_ids.public[0]
}
module "database" {
  source            = "./modules/04.database"
  subnet_ids        = module.vpc.subnet_ids.private
  security_group_id = module.vpc.postgres_security_group.id
  database_configs  = local.database
}
module "ecs_cluster" {
  source = "./modules/05.ecs-cluster"
}
module "ecs_launch_template" {
  source = "./modules/06.launch-template"
  ami_id = local.ecs_launch_template_ami_id
  security_groups = {
    api = module.vpc.api_security_group
    ui  = module.vpc.ui_security_group
  }
  ecs_cluster                    = module.ecs_cluster
  ecs_instance_role_profile_name = module.iam_role.ecs_instance_role.profile_name
  key_pair_name                  = local.key_pair_name
}
module "auto_scaling_group" {
  source             = "./modules/07.auto-scaling-group"
  public_subnet_ids  = module.vpc.subnet_ids.public
  private_subnet_ids = module.vpc.subnet_ids.private
  launch_template    = module.ecs_launch_template
}
module "load_balancer" {
  source          = "./modules/08.load-balancer"
  security_groups = [module.vpc.api_security_group.id]
  subnet_ids      = module.vpc.subnet_ids.private
  vpc_id          = module.vpc.vpc_id
}

module "ecs_task_definition" {
  source                  = "./modules/09.task-definition"
  ecs_task_execution_role = module.iam_role.ecs_task_execution_role
  region                  = local.region
  database_url            = "postgresql://${local.database.username}:${module.database.password}@${module.database.address}:${local.database.port}/${local.database.name}?schema=public"
  next_public_backend_url = module.load_balancer.api.dns_name
  depends_on              = [module.database]
}
module "ecs_service" {
  source              = "./modules/10.ecs-service"
  ecs_cluster         = module.ecs_cluster
  ecs_task_definition = module.ecs_task_definition
  target_group        = module.load_balancer.target_group
}
module "auto_scaling_ecs_api_task" {
  source               = "./modules/11.auto-scaling-ecs-api-task"
  ecs_api_service_name = module.ecs_service.api.name
  ecs_cluster          = module.ecs_cluster
  auto_scaling_group   = module.auto_scaling_group

  depends_on = [module.ecs_service]
}

# data "aws_instances" "api_instances" {
#   filter {
#     name   = "tag:Name"
#     values = ["ecs-api-instance"]
#   }
#   depends_on = [module.ecs_service]
# }



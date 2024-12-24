provider "aws" {
  region = local.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
  backend "s3" {
    bucket = "kysomaio-terraform-state"  # Tên bucket đã tạo
    key    = "v.1.0.1/terraform.tfstate" # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}
# resource "tls_private_key" "dev_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = local.key_pair_name
#   public_key = tls_private_key.dev_key.public_key_openssh
#   provisioner "local-exec" {
#     command = <<-EOT
#       rm -rf ${local.key_pair_name}.pem
#       echo "${tls_private_key.dev_key.private_key_pem}" > "${local.key_pair_name}".pem
#       chmod 400 "${local.key_pair_name}".pem
#     EOT
#   }

# }

module "vpc" {
  source      = "../../common-modules/01.vpc"
  tag_version = local.tag_version
}

module "iam_role" {
  source      = "../../common-modules/02.iam-role"
  tag_version = local.tag_version
}

# module "bastion_host" {
#   source            = "../../common-modules/03.bastion-host"
#   key_name          = local.key_pair_name
#   security_group_id = module.vpc.security_groups["bastion-host-security-group"].id
#   subnet_id         = module.vpc.subnet_ids.public[0]
#   tag_version       = local.tag_version
# }
module "database" {
  source            = "./modules/00.database"
  subnet_ids        = module.vpc.subnet_ids.private
  security_group_id = module.vpc.security_groups["postgres-security-group"].id
  database_configs  = local.database
  tag_version       = local.tag_version
}
# module "ecs_cluster" {
#   source      = "../../common-modules/05.ecs-cluster"
#   tag_version = local.tag_version
# }
# module "ecs_launch_template" {
#   source = "../../common-modules/06.launch-template"
#   ami_id = local.ecs_launch_template_ami_id
#   security_groups = {
#     api = { id = module.vpc.security_groups["api-security-group"].id }
#     ui  = { id = module.vpc.security_groups["ui-security-group"].id }
#   }
#   ecs_cluster                    = module.ecs_cluster
#   ecs_instance_role_profile_name = module.iam_role.ecs_instance_role.profile_name
#   key_pair_name                  = local.key_pair_name
#   tag_version                    = local.tag_version
# }
# module "auto_scaling_group" {
#   source             = "../../common-modules/07.auto-scaling-group"
#   public_subnet_ids  = module.vpc.subnet_ids.public
#   private_subnet_ids = module.vpc.subnet_ids.private
#   launch_template    = module.ecs_launch_template
#   tag_version        = local.tag_version
# }
# module "load_balancer" {
#   source              = "../../common-modules/08.load-balancer"
#   api_security_groups = [module.vpc.security_groups["api-security-group"].id]
#   ui_security_groups  = [module.vpc.security_groups["ui-security-group"].id]
#   subnet_ids          = module.vpc.subnet_ids
#   vpc_id              = module.vpc.vpc_id
#   tag_version         = local.tag_version
# }

# module "ecs_task_definition" {
#   source                  = "../../common-modules/09.task-definition"
#   ecs_task_execution_role = module.iam_role.ecs_task_execution_role
#   region                  = local.region
#   database_url            = "postgresql://${local.database.username}:${module.database.password}@${module.database.address}:${local.database.port}/${local.database.name}?schema=public"
#   next_public_backend_url = "${module.load_balancer.api.dns_name}:4000/api"
#   depends_on              = [module.database]
#   ui_load_balancer_url    = "${module.load_balancer.ui.dns_name}:3000"
#   tag_version             = local.tag_version
# }
# module "ecs_service" {
#   source              = "../../common-modules/10.ecs-service"
#   ecs_cluster         = module.ecs_cluster
#   ecs_task_definition = module.ecs_task_definition
#   target_group        = module.load_balancer.target_group
#   tag_version         = local.tag_version
# }
# module "auto_scaling_ecs_api_task" {
#   source               = "../../common-modules/11.auto-scaling-ecs-api-task"
#   ecs_api_service_name = module.ecs_service.api.name
#   ecs_cluster          = module.ecs_cluster
#   auto_scaling_group   = module.auto_scaling_group
#   tag_version          = local.tag_version

#   depends_on = [module.ecs_service]
# }

# data "aws_instances" "api_instances" {
#   filter {
#     name   = "tag:Name"
#     values = ["ecs-api-instance"]
#   }
#   depends_on = [module.ecs_service]
# }



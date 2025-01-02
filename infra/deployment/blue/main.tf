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
    key    = "v.2.0.0/terraform.tfstate" # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}

module "shared" {
  source      = "../../modules/00.shared"
  environment = var.environment
  region      = var.region
}

module "bastion_host" {
  source            = "../../modules/03.bastion-host"
  key_name          = var.key_pair_name
  security_group_id = module.shared.vpc.security_groups.bastion_host.id
  subnet_id         = module.shared.vpc.subnets.public.ids[0]
  tag_version       = var.tag_version
}

module "database" {
  source            = "../../modules/04.database"
  security_group_id = module.shared.vpc.security_groups.postgres.id
  subnet_ids        = module.shared.vpc.subnets.private.ids
  tag_version       = var.tag_version
  database_configs  = var.database
}

module "ecs_cluster" {
  source      = "../../modules/05.ecs-cluster"
  tag_version = var.tag_version
}

module "ecs_launch_template" {
  source                         = "../../modules/06.launch-template"
  ecs_cluster                    = module.ecs_cluster
  ecs_instance_role_profile_name = module.shared.iam_role.ecsInstanceRole.profile_name
  security_groups = {
    api = { id = module.shared.vpc.security_groups["api"].id }
    ui  = { id = module.shared.vpc.security_groups["ui"].id }
  }
  key_pair_name = var.key_pair_name
  tag_version   = var.tag_version
}

module "auto_scaling_group" {
  source             = "../../modules/07.auto-scaling-group"
  public_subnet_ids  = module.shared.vpc.subnets.public.ids
  private_subnet_ids = module.shared.vpc.subnets.private.ids
  launch_template    = module.ecs_launch_template
  tag_version        = var.tag_version
}

module "load_balancer" {
  source              = "../../modules/08.load-balancer"
  api_security_groups = [module.shared.vpc.security_groups["api"].id]
  ui_security_groups  = [module.shared.vpc.security_groups["ui"].id]
  subnet_ids = {
    public  = module.shared.vpc.subnets.public.ids,
    private = module.shared.vpc.subnets.private.ids
  }
  vpc_id      = module.shared.vpc.id
  tag_version = var.tag_version
}

module "ecs_task_definition" {
  source                  = "../../modules/09.task-definition"
  ecs_task_execution_role = module.shared.iam_role.ecsTaskExecutionRole
  region                  = var.region
  database_url            = "postgresql://${var.database.username}:${var.database.password}@${module.database.address}:${var.database.port}/${var.database.name}?schema=public"
  next_public_backend_url = "${module.load_balancer.api.dns_name}:4000/api"
  depends_on              = [module.database]
  ui_load_balancer_url    = "${module.load_balancer.ui.dns_name}:3000"
  tag_version             = var.tag_version
}

module "ecs_service" {
  source              = "../../modules/10.ecs-service"
  ecs_cluster         = module.ecs_cluster
  ecs_task_definition = module.ecs_task_definition
  target_group        = module.load_balancer.target_group
  tag_version         = var.tag_version
}

module "auto_scaling_ecs_api_task" {
  source               = "../../modules/11.auto-scaling-ecs-api-task"
  ecs_api_service_name = module.ecs_service.api.name
  ecs_cluster          = module.ecs_cluster
  auto_scaling_group   = module.auto_scaling_group
  tag_version          = var.tag_version
  depends_on           = [module.ecs_service]
}

output "iam_role" {
  value = {
    ecsInstanceRole      = { profile_name = data.aws_iam_instance_profile.ecs_instance_profile.name }
    ecsTaskExecutionRole = { arn = data.aws_iam_role.ecs_task_execution_role.arn }
  }
}
output "vpc" {
  value = {
    id = data.aws_vpc.vpc.id
    subnets = {
      public = {
        ids = [for v in data.aws_subnet.public : v.id]
      }
      private = {
        ids = [for v in data.aws_subnet.private : v.id]
      }
    }
    igw = {
      id = data.aws_internet_gateway.igw.id
    }
    nat = {
      ids = data.aws_nat_gateways.nat.ids
    }
    security_groups = {
      bastion_host = { id = data.aws_security_groups.bastion_host.ids[0] }
      api          = { id = data.aws_security_groups.api.ids[0] }
      ui           = { id = data.aws_security_groups.ui.ids[0] }
      postgres     = { id = data.aws_security_groups.postgres.ids[0] }
    }
  }
}


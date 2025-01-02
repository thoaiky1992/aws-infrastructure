data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"                 # Replace with your tag key
    values = ["${var.environment}-vpc"] # Replace with your tag value
  }
}
data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.environment}-ecsInstanceProfile"
}
data "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-ecsTaskExecutionRole"
}
data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "${var.environment}-ecsTaskExecutionRole"
}

data "aws_subnet" "public" {
  count = 2
  filter {
    name   = "tag:Name"                     # Replace with your tag key
    values = ["${var.environment}-public*"] # Replace with your tag value
  }
  filter {
    name   = "cidrBlock"
    values = [var.subnets.public.cidr_block[count.index]] # Replace with your specific CIDR block
  }
}
data "aws_subnet" "private" {
  count = 2
  filter {
    name   = "tag:Name"                      # Replace with your tag key
    values = ["${var.environment}-private*"] # Replace with your tag value
  }
  filter {
    name   = "cidrBlock"
    values = [var.subnets.private.cidr_block[count.index]] # Replace with your specific CIDR block
  }
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "tag:Name"                              # Replace with your tag key
    values = ["${var.environment}-internet-gateway"] # Replace with your tag value
  }
}

data "aws_nat_gateways" "nat" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-main-nat-gateway*"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_security_groups" "bastion_host" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-bastion-host*"]
  }
}
data "aws_security_groups" "api" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-api*"]
  }
}
data "aws_security_groups" "ui" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-ui*"]
  }
}
data "aws_security_groups" "postgres" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-postgres*"]
  }
}

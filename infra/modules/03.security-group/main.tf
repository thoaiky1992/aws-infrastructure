resource "aws_security_group" "bastion_host_security_group" {
  name   = "bastion-host-security-group"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.bastion_host_security_group.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.bastion_host_security_group.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "bastion-host-security-group"
  }
}
resource "aws_security_group" "postgres_security_group" {
  name   = "postgres-security-group"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.postgres_security_group.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.postgres_security_group.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "postgres-security-group"
  }
}
resource "aws_security_group" "api_security_group" {
  name   = "api-security-group"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.api_security_group.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.api_security_group.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "api-security-group"
  }
}
resource "aws_security_group" "ui_security_group" {
  name   = "ui-security-group"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.ui_security_group.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.ui_security_group.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "ui-security-group"
  }
}
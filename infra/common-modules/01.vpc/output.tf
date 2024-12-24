
output "subnet_ids" {
  value = module.subnets.subnet_ids
}

output "security_groups" {
  value = { for k, v in module.security_group.list : k => { id = v.id } }
}

output "vpc_id" {
  value = aws_vpc.main.id
}


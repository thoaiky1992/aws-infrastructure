
output "subnet_ids" {
  value = module.subnets.subnet_ids
}

output "bastion_host_security_group" {
  value = module.security_group.bastion_host_security_group
}
output "postgres_security_group" {
  value = module.security_group.postgres_security_group
}
output "api_security_group" {
  value = module.security_group.api_security_group
}
output "ui_security_group" {
  value = module.security_group.ui_security_group
}
output "vpc_id" {
  value = aws_vpc.main.id
}


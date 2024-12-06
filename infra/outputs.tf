output "bastion_host_public_ip" {
  value = module.bastion_host.public_id
}
output "database_info" {
  value = {
    address  = module.database.address
    password = module.database.password
  }
}

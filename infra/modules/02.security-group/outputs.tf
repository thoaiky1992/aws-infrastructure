output "bastion_host_security_group" {
  value = {
    id = aws_security_group.bastion_host_security_group.id
  }
}
output "postgres_security_group" {
  value = {
    id = aws_security_group.postgres_security_group.id
  }
}
output "api_security_group" {
  value = {
    id = aws_security_group.api_security_group.id
  }
}
output "ui_security_group" {
  value = {
    id = aws_security_group.ui_security_group.id
  }
}
output "prometheus_security_group" {
  value = {
    id = aws_security_group.prometheus_security_group.id
  }
}
output "grafana_security_group" {
  value = {
    id = aws_security_group.grafana_security_group.id
  }
}


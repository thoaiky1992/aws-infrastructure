locals {
  bastion_host_security_group = {
    ingress = [{ from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }]
    egress  = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
  }

  postgres_security_group = {
    ingress = [{ from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }]
    egress  = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
  }

  api_security_group = {
    ingress = [
      { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
      { from_port = 4000, to_port = 4000, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }
    ]
    egress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
  }

  ui_security_group = {
    ingress = [
      { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    ]
    egress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
  }
}

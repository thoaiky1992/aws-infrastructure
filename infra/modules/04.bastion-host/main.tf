resource "aws_instance" "bastion" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
  key_name        = var.key_name

  user_data = templatefile("${path.module}/bastion-host.sh.tftpl", {
    SSH_KEY             = var.ssh_key
    BACKEND_URL         = var.backend_url
    DOCKER_HUB_PASSWORD = var.docker_hub_password
  })

  tags = {
    Name = "bastion-host"
  }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

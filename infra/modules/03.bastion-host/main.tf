resource "aws_instance" "bastion" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]
  key_name        = var.key_name

  user_data = templatefile("${path.module}/bastion-host.sh.tftpl", {})

  tags = {
    Name = "bastion-host"
  }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

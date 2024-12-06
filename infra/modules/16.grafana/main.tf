data "aws_ami" "amzn_linux_2023_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "grafana_instance" {
  ami                    = data.aws_ami.amzn_linux_2023_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.ecs_instance_role.profile_name
  key_name               = var.key_pair_name

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp2"
  }

  user_data = templatefile("${path.module}/grafana-install.sh.tftpl", {})
  tags = {
    "Name" = "grafana-instance"
  }
}
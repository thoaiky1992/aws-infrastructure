resource "aws_launch_template" "ecs_api_launch_template" {
  name_prefix   = "${var.tag_version}-ecs-app-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [var.security_groups.api.id]
  iam_instance_profile {
    name = var.ecs_instance_role_profile_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_version}-ecs-api-instance"
    }
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", { ECS_CLUSTER_NAME = "${var.ecs_cluster.api.name}" }))
}

resource "aws_launch_template" "ecs_ui_launch_template" {
  name_prefix   = "${var.tag_version}-ecs-ui-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [var.security_groups.ui.id]
  iam_instance_profile {
    name = var.ecs_instance_role_profile_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_version}-ecs-ui-instance"
    }
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", { ECS_CLUSTER_NAME = var.ecs_cluster.ui.name }))
}

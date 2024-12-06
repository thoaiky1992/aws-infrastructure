variable "security_group_ids" {
  description = "List of security group IDs for the Grafana instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "The subnet ID where the Grafana instance will be deployed"
  type        = string
}

variable "ecs_instance_role" {
  description = "The IAM instance profile for the ECS instance"
  type = object({
    profile_name = string
  })
}

variable "key_pair_name" {
  description = "The key pair name to use for SSH access to the Grafana instance"
  type        = string
}

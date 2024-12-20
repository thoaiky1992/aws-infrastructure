variable "ami_id" {
  description = "The AMI ID for the ECS instances"
  type        = string
  default     = "ami-02865bbb5ac96158d"
}

variable "instance_type" {
  description = "The instance type for the ECS instances"
  type        = string
  default     = "t2.small"
}

variable "key_pair_name" {
  description = "The key pair name to use for SSH access to the ECS instances"
  type        = string
}

variable "security_groups" {
  description = "Security groups for the ECS instances"
  type = object({
    api = object({
      id = string
    })
    ui = object({
      id = string
    })
  })
}

variable "ecs_instance_role_profile_name" {
  description = "The IAM instance profile name for the ECS instances"
  type        = string
}

variable "ecs_cluster" {
  description = "ECS cluster names for the API and UI"
  type = object({
    api = object({
      name = string
    })
    ui = object({
      name = string
    })
  })
}
variable "environment" {
  type = string
}

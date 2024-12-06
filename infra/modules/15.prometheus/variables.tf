variable "security_group_ids" {
  description = "List of security group IDs for the Prometheus instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "The subnet ID where the Prometheus instance will be deployed"
  type        = string
}

variable "ecs_instance_role" {
  description = "The IAM instance profile for the ECS instance"
  type = object({
    profile_name = string
  })
}

variable "key_pair_name" {
  description = "The key pair name to use for SSH access to the Prometheus instance"
  type        = string
}

variable "region" {
  description = "The AWS region where the resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_access_key" {
  description = "The AWS access key for Prometheus setup"
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS secret key for Prometheus setup"
  type        = string
}

variable "instance_tag_regex" {
  description = "The regex pattern to match instance tags for Prometheus"
  type        = string
}

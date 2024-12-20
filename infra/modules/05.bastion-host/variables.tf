variable "ami_id" {
  description = "The AMI ID for the bastion host"
  type        = string
  default     = "ami-07757425cb19b6564" // amzn2-ami-ecs-hvm-2.0.20241108-x86_64-ebs (region: Singapore)
}

variable "instance_type" {
  description = "The instance type for the bastion host"
  type        = string
  default     = "t2.small"
}

variable "subnet_id" {
  description = "The subnet ID where the bastion host will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the bastion host"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for SSH access to the bastion host"
  type        = string
}

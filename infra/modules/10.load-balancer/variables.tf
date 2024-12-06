variable "security_groups" {
  description = "List of security group IDs for the load balancer"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer and target group will be deployed"
  type        = string
}

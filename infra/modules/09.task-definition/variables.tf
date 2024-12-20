variable "ecs_task_execution_role" {
  description = "The ARN of the IAM role that allows ECS tasks to make calls to AWS services"
  type        = object({
    arn = string
  })
}

variable "region" {
  description = "The AWS region where the resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "database_url" {
  description = "The URL of the database to be used by the ECS API service"
  type        = string
}

variable "next_public_backend_url" {
  type = string
}
variable "ui_load_balancer_url" {
  type = string
}
variable "environment" {
  type = string
}
variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    api = object({
      name = string
    })
  })
}

variable "ecs_api_service_name" {
  description = "The name of the ECS API service"
  type        = string
}

variable "auto_scaling_group" {
  description = "Auto scaling group details"
  type = object({
    api = object({
      name = string
    })
  })
}

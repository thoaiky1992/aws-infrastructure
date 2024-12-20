variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    api = object({
      id = string
    })
    ui = object({
      id = string
    })
  })
}

variable "ecs_task_definition" {
  description = "ECS task definition details"
  type = object({
    api = object({
      arn = string
    })
    ui = object({
      arn = string
    })
  })
}

variable "target_group" {
  description = "Target group details"
  type = object({
    api = object({
      arn = string
    })
  })
}

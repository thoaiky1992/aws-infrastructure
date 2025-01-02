variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS API auto scaling group"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ECS UI auto scaling group"
  type        = list(string)
}

variable "launch_template" {
  description = "Launch templates for the ECS API and UI"
  type = object({
    api = object({
      id = string
    })
    ui = object({
      id = string
    })
  })
}
variable "tag_version" {
  type = string
}

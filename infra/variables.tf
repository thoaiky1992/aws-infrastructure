variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "key_pair_name" {
  type = string
}
variable "ssh_private_key" {
  type = string
}
variable "ecs_launch_template_ami_id" {
  type = string
  default = "ami-02865bbb5ac96158d"
}
variable "database" {
  type = object({
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    name                 = string
    username             = string
    password             = string
    port                 = number
    parameter_group_name = string
    skip_final_snapshot  = bool
    publicly_accessible  = bool
  })
}
variable "environment" {
  type = string
}


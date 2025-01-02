variable "region" {
  type = string
}
variable "tag_version" {
  type = string
}
variable "key_pair_name" {
  type = string
}
variable "environment" {
  type = string
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
variable "ssh_private_key" {
  type = string
}
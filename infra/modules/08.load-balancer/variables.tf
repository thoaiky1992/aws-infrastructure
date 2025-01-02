variable "api_security_groups" {
  description = "List of api security group IDs for the load balancer"
  type        = list(string)
}
variable "ui_security_groups" {
  description = "List of ui security group IDs for the load balancer"
  type        = list(string)
}

variable "subnet_ids" {
  type        = object({
    public = list(string)
    private = list(string)
  })
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer and target group will be deployed"
  type        = string
}
variable "tag_version" {
  type = string
}

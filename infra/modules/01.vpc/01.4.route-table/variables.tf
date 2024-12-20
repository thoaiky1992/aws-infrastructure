variable "vpc_id" {
  type = string
}
variable "igw_id" {
  type = string
}
variable "private_route_table_count" {
  type = number
}
variable "nat_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = object({
    public = list(string)
    private = list(string)
  })
}
variable "environment" {
  type = string
}
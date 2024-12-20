variable "nat_count" {
  type = number
  default = 2
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
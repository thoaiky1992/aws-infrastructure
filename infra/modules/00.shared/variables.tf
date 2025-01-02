variable "environment" {
  description = "Environment name"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
}

variable "subnets" {
  type = object({
    public = object({
      cidr_block = list(string)
    })
    private = object({
      cidr_block = list(string)
    })
  })
  default = {
    public = {
      cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
    }
    private = {
      cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
    }
  }
}

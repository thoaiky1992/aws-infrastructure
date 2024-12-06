/*
  CIDR /16 tương đương với 65,536 địa chỉ IP (từ 10.0.0.0 đến 10.0.255.255).
*/
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
/*
  CIDR /24 cung cấp 256 địa chỉ IP, nhưng AWS dành trước 5 địa chỉ (0, 1, 2, 3, 255),
  nên thực tế có 251 địa chỉ khả dụng cho tài nguyên (EC2, Load Balancer, etc.).
*/
variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = [
    { name = "public_subnet_1", cidr_block = "10.0.1.0/24", availability_zone = "ap-southeast-1a", map_public_ip_on_launch = true },
    { name = "public_subnet_2", cidr_block = "10.0.2.0/24", availability_zone = "ap-southeast-1b", map_public_ip_on_launch = true },
    { name = "private_subnet_1", cidr_block = "10.0.3.0/24", availability_zone = "ap-southeast-1a", map_public_ip_on_launch = false },
    { name = "private_subnet_2", cidr_block = "10.0.4.0/24", availability_zone = "ap-southeast-1b", map_public_ip_on_launch = false }
  ]
}

output "ids" {
  value = [for v in aws_nat_gateway.nat : v.id]
}

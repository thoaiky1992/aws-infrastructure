output "vpc_id" {
  value = aws_vpc.main.id
}
/*
  Output:
  {
    "public_subnet_1": { id = "subnet-0abcd1234efgh5678" },
    "public_subnet_2": { id = "subnet-1abcd1234efgh5678" }",
    "private_subnet_1": { id = "subnet-2abcd1234efgh5678" },
    "private_subnet_2": { id = "subnet-3abcd1234efgh5678" }
  }
*/
# output "subnet_ids" {
#   value = { for k, v in aws_subnet.subnets : k => { id = v.id } }
# }
/*
  {
    public  = ["subnet-0abcd1234efgh5678", "subnet-1abcd1234efgh5678"]
    private = ["subnet-2abcd1234efgh5678", "subnet-3abcd1234efgh5678"]
  }
*/
output "subnet_ids" {
  value = {
    public  = [for k, v in aws_subnet.subnets : v.id if startswith(k, "public")]
    private = [for k, v in aws_subnet.subnets : v.id if startswith(k, "private")]
  }
}

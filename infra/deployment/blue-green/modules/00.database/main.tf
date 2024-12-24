module "rds_blue_green" {
  source  = "terraform-aws-modules/rds/aws//examples/blue-green-deployment"
  version = "6.10.0"
}
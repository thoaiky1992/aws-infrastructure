region = "ap-southeast-1"
tag_version = "v.2.0.0"
key_pair_name = "aws-key"
environment = "dev"
database = {
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  name                 = "app"
  username             = "postgres"
  password             = "postgres"
  port                 = 5432
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  publicly_accessible  = false
}
ssh_private_key            = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA7V1
-----END RSA PRIVATE KEY-----
EOF

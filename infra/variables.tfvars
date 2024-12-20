ssh_private_key            = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA7V1...
... (nội dung private key của bạn) ...
-----END RSA PRIVATE KEY-----
EOF
key_pair_name              = "aws-key"
region                     = "ap-southeast-1"
ecs_launch_template_ami_id = "ami-02865bbb5ac96158d"
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
environment = "dev"

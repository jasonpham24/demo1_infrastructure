# 1. Security Groups
module "security_groups" {
  source              = "./modules/security_groups"
  name                = "demo1-infra"
  vpc_id              = data.aws_vpc.default.id
  allowed_ssh_cidrs   = var.allowed_ssh_cidrs
  ec2_instance_ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 2. IAM Roles & Profile
module "iam" {
  source                = "./modules/iam"
  name                  = "demo1-infra"
  assume_role_policy_json = data.aws_iam_policy_document.assume_role.json
  ec2_policy_json       = data.aws_iam_policy_document.ec2_policy.json
}

# 3. Foundation EC2 (Bastion / Host) running in default VPC
module "ec2" {
  source                    = "./modules/ec2"
  name                      = "demo1-infra"
  vpc_id                    = data.aws_vpc.default.id
  subnet_id                 = element(data.aws_subnets.default.ids, 0)
  ami_id                    = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.ubuntu.value
  instance_type             = "t3.medium"
  create_ssh_key            = true
  private_key_path          = var.private_key_path
  iam_instance_profile_name = module.iam.instance_profile_name
  security_group_id         = module.security_groups.ec2_instance_security_group_id
  default_vpc_id            = data.aws_vpc.default.id
  ebs_volume_type           = "gp3"

  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}
# 4. S3 Bucket for demo static assets
module "s3" {
  source      = "./modules/s3"
  bucket_name = "demo1-bucket-8391983313331"
  force_destroy = true
  versioning_status = "Enabled"
  sse_algorithm = "AES256"
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 5.  CloudFront CDN for S3 static site
module "cloudfront" {
  source              = "./modules/cloudfront"
  name                = "demo1-infra-cdn"
  bucket_id           = module.s3.bucket_id
  aliases             = []
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 6.  Cloudflare DNS records
locals {
  subdomains = {
    grafana    = "grafana"
    prometheus = "prometheus"
    n8n        = "n8n"
  }
}

module "cloudflare_dns" {
  for_each     = local.subdomains
  source       = "./modules/cloudflare"
  zone_name    = "c1nd3r.site"
  zone_id      = var.zone_id
  record_name  = each.value
  record_type  = "A"
  record_value = module.ec2.public_ip
  ttl          = 1
  proxied      = false
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 7. RDS PostgreSQL in default VPC subnets
module "rds" {
  source                = "./modules/rds"
  name                  = "demo1-infra-db"
  vpc_id                = data.aws_vpc.default.id
  subnet_ids            = data.aws_subnets.default.ids
  db_password           = var.db_password
  security_group_id     = module.security_groups.rds_database_security_group_id
  engine                = "postgres"
  max_allocated_storage = 100
  skip_final_snapshot   = true
  publicly_accessible   = false

  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 8.  Elastic Beanstalk scaffolding for demo 1.2
module "beanstalk" {
  source                     = "./modules/beanstalk"
  application_name           = "demo1-infra-app"
  environment_name           = "demo1-infra-env"
  solution_stack_name        = var.beanstalk_solution_stack_name
  application_version_label  = ""
  application_version_bucket = ""
  application_version_key    = ""
  environment_instance_type  = "t3.small"
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

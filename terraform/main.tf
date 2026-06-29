# 1. Security Groups
module "security_groups" {
  source              = "./modules/security_groups"
  name                = var.instance_name
  vpc_id              = data.aws_vpc.default.id
  allowed_ssh_cidrs   = var.allowed_ssh_cidrs
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 2. IAM Roles & Profile
module "iam" {
  source = "./modules/iam"
  name   = var.instance_name
}

# 3. Foundation EC2 (Bastion / Host) running in default VPC
module "ec2" {
  source                    = "./modules/ec2"
  name                      = var.instance_name
  vpc_id                    = data.aws_vpc.default.id
  subnet_id                 = element(data.aws_subnets.default.ids, 0)
  ami_id                    = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.ubuntu.value
  instance_type             = var.instance_type
  create_ssh_key            = var.create_ssh_key
  private_key_path          = var.private_key_path
  iam_instance_profile_name = module.iam.instance_profile_name
  security_group_id         = module.security_groups.web_server_security_group_id

  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 4. S3 Bucket for demo static assets
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 5.  CloudFront CDN for S3 static site
module "cloudfront" {
  source              = "./modules/cloudfront"
  name                = "${var.instance_name}-cdn"
  bucket_id           = module.s3.bucket_id
  aliases             = var.cloudfront_aliases
  default_root_object = var.cloudfront_default_root_object
  price_class         = var.cloudfront_price_class
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 6.  Cloudflare DNS record
module "cloudflare" {
  source       = "./modules/cloudflare"
  zone_id      = var.cloudflare_zone_id
  zone_name    = var.cloudflare_zone
  record_name  = var.cloudflare_record_name
  record_type  = var.cloudflare_record_type
  record_value = var.cloudflare_record_value != "" ? var.cloudflare_record_value : module.ec2.public_dns
  ttl          = var.cloudflare_ttl
  proxied      = var.cloudflare_record_proxied
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 7. RDS PostgreSQL in default VPC subnets
module "rds" {
  source                = "./modules/rds"
  name                  = "${var.instance_name}-db"
  vpc_id                = data.aws_vpc.default.id
  subnet_ids            = data.aws_subnets.default.ids
  db_password           = var.db_password
  security_group_id     = module.security_groups.database_security_group_id

  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 8.  Elastic Beanstalk scaffolding for demo 1.2
module "beanstalk" {
  source                     = "./modules/beanstalk"
  application_name           = var.beanstalk_application_name
  environment_name           = var.beanstalk_environment_name
  solution_stack_name        = var.beanstalk_solution_stack_name
  application_version_label  = var.beanstalk_application_version_label
  application_version_bucket = var.beanstalk_application_version_bucket
  application_version_key    = var.beanstalk_application_version_key
  environment_instance_type  = var.beanstalk_instance_type
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

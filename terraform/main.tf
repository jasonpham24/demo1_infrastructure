terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token != "" ? var.cloudflare_api_token : null
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
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
  record_value = var.cloudflare_record_value
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
  ec2_security_group_id = module.ec2.security_group_id

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

locals {
  ansible_inventory_host_line = "${module.ec2.public_ip} ansible_user=${var.ssh_user}${var.private_key_path != "" ? " ansible_ssh_private_key_file=${var.private_key_path}" : ""}"
  ansible_inventory_content = <<EOF
[demo]
${local.ansible_inventory_host_line}

[demo:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory/inventory.ini"
  content  = local.ansible_inventory_content
}

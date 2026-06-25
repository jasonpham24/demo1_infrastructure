terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Query Default VPC and Subnets from AWS
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. IAM Roles & Profile
module "iam" {
  source = "./modules/iam"
  name   = var.instance_name
}

# 3. Foundation EC2 (Bastion / Host) running in Default VPC
module "ec2" {
  source                    = "./modules/ec2"
  name                      = var.instance_name
  vpc_id                    = data.aws_vpc.default.id
  subnet_id                 = data.aws_subnets.default.ids[0]
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  ssh_public_key            = var.ssh_public_key
  iam_instance_profile_name = module.iam.instance_profile_name

  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 4. S3 Bucket
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags = {
    Environment = "demo"
    Project     = "demo1"
  }
}

# 5. RDS PostgreSQL running in Default VPC Subnets
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

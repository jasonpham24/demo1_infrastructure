variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_name" {
  description = "Base name for provisioned resources"
  type        = string
  default     = "demo1-stack"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (optional). If empty, Terraform will fetch the latest Ubuntu 22.04 LTS AMI from AWS SSM."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "private_key_path" {
  description = "Path to the SSH private key file used to access the EC2 instance"
  type        = string
  default     = ""
}

variable "create_ssh_key" {
  description = "Create a new SSH key pair for EC2 and save the private key to private_key_path"
  type        = bool
  default     = false
}

variable "ssh_user" {
  description = "SSH user for connecting to the EC2 instance"
  type        = string
  default     = "ubuntu"
}

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "Password for the RDS PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
  default     = "demo1-automation-backups-bucket-79db7b"
}

variable "cloudfront_aliases" {
  description = "Alternate domain names for CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "cloudfront_price_class" {
  description = "CloudFront price class to limit edge locations"
  type        = string
  default     = "PriceClass_100"
}

variable "cloudfront_default_root_object" {
  description = "Default root object for CloudFront distribution"
  type        = string
  default     = "index.html"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token. You can set this value via environment variable CLOUDFLARE_API_TOKEN or via Terraform variable input."
  type        = string
  default     = ""
  sensitive   = true
}

variable "zone_id" {
  description = "Cloudflare zone ID where DNS records should be created"
  type        = string
  default     = ""
}

variable "beanstalk_application_name" {
  description = "Elastic Beanstalk application name"
  type        = string
  default     = ""
}

variable "beanstalk_environment_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
  default     = ""
}

variable "beanstalk_solution_stack_name" {
  description = "Elastic Beanstalk solution stack/platform"
  type        = string
  default     = "64bit Amazon Linux 2 v5.9.15 running Node.js 18"
}

variable "beanstalk_application_version_label" {
  description = "Elastic Beanstalk application version label"
  type        = string
  default     = ""
}

variable "beanstalk_application_version_bucket" {
  description = "S3 bucket that stores the Elastic Beanstalk application version zip"
  type        = string
  default     = ""
}

variable "beanstalk_application_version_key" {
  description = "S3 object key for the Elastic Beanstalk application version zip"
  type        = string
  default     = ""
}

variable "beanstalk_instance_type" {
  description = "EC2 instance type for Elastic Beanstalk environment"
  type        = string
  default     = "t3.small"
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR ranges allowed to SSH to the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

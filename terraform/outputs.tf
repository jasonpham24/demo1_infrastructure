output "vpc_id" {
  description = "The ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "vpc_subnet_ids" {
  description = "The IDs of the subnets in the default VPC"
  value       = data.aws_subnets.default.ids
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = module.ec2.public_dns
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS database"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  description = "The host address for the RDS database"
  value       = module.rds.rds_address
}

output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name"
  value       = try(module.cloudfront.distribution_domain_name, null)
}

output "beanstalk_environment_url" {
  description = "The URL of the Elastic Beanstalk environment"
  value       = try(module.beanstalk.environment_url, null)
}

output "cloudflare_record_name" {
  description = "The Cloudflare DNS record created for the project"
  value       = try(module.cloudflare.record_name, null)
}

output "ansible_inventory_path" {
  description = "Path to the generated Ansible inventory file"
  value       = "${path.root}/../ansible/inventory/inventory.ini"
}

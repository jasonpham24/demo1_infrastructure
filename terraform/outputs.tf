output "vpc_id" {
  description = "The ID of the default VPC"
  value       = data.aws_vpc.default.id
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

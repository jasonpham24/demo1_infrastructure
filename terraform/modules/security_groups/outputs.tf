output "ec2_instance_security_group_id" {
  description = "The ID of the EC2 instance security group"
  value       = aws_security_group.ec2_instance.id
}

output "rds_database_security_group_id" {
  description = "The ID of the RDS database security group"
  value       = aws_security_group.rds_database.id
}

output "ec3_instance_security_group_id" {
  description = "The ID of the web server security group"
  value       = aws_security_group.web_server.id
}

output "rds_database_security_group_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.database.id
}

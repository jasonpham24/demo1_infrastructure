output "rds_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "rds_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "rds_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.this.db_name
}

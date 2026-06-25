variable "name" {
  description = "Base name for RDS resources"
  type        = string
  default     = "demo-db"
}

variable "vpc_id" {
  description = "VPC ID where the database and security groups will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the database subnet group"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "n8n"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "ec2_security_group_id" {
  description = "The security group ID of the EC2 instance that needs database access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to RDS resources"
  type        = map(string)
  default     = {}
}

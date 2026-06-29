resource "aws_security_group" "ec2_instance" {
  name        = "${var.name}-ec2-instance-sg"
  description = "Security group for ${var.name} ec2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-ec2-instance-sg"
  }, var.tags)
}

resource "aws_security_group" "rds_database" {
  name        = "${var.name}-rds-database-sg"
  description = "Security group for ${var.name} RDS database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow connection from EC2 instance"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_instance.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-rds-database-sg"
  }, var.tags)
}

resource "aws_security_group" "ec2_instance" {
  name        = "${var.name}-ec2-instance-sg"
  description = "Security group for ${var.name} EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_instance_ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
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

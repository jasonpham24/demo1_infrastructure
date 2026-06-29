resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "DB subnet group for ${var.name}"

  tags = merge(
    {
      Name = "${var.name}-subnet-group"
    },
    var.tags
  )
}

resource "aws_db_instance" "this" {
  identifier             = var.name
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = 100
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

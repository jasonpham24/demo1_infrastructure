resource "aws_security_group" "ec2_instance" {
  name        = "${var.name}-ec2-instance-sg"
  description = "Security group for ${var.name} EC2 instance"
  vpc_id      = var.vpc_id
  lifecycle { create_before_destroy = true }
  tags = merge({ Name = "${var.name}-ec2-instance-sg" }, var.tags)
}

resource "aws_security_group" "rds_database" {
  name        = "${var.name}-rds-database-sg"
  description = "Security group for ${var.name} RDS database"
  vpc_id      = var.vpc_id
  lifecycle { create_before_destroy = true }
  tags = merge({ Name = "${var.name}-rds-database-sg" }, var.tags)
}

resource "aws_security_group_rule" "ec2_ingress_cidr" {
  for_each          = { for rule in var.ec2_instance_ingress_cidr_rules : rule.description => rule }
  type              = "ingress"
  security_group_id = aws_security_group.ec2_instance.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "ec2_ingress_sg" {
  for_each                 = { for rule in var.ec2_instance_ingress_sg_rules : rule.description => rule }
  type                     = "ingress"
  security_group_id        = aws_security_group.ec2_instance.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "ec2_egress_cidr" {
  for_each          = { for rule in var.ec2_instance_egress_cidr_rules : rule.description => rule }
  type              = "egress"
  security_group_id = aws_security_group.ec2_instance.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "ec2_egress_sg" {
  for_each                 = { for rule in var.ec2_instance_egress_sg_rules : rule.description => rule }
  type                     = "egress"
  security_group_id        = aws_security_group.ec2_instance.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "rds_ingress_cidr" {
  for_each          = { for rule in var.rds_database_ingress_cidr_rules : rule.description => rule }
  type              = "ingress"
  security_group_id = aws_security_group.rds_database.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "rds_ingress_sg" {
  for_each                 = { for rule in var.rds_database_ingress_sg_rules : rule.description => rule }
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_database.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "rds_egress_cidr" {
  for_each          = { for rule in var.rds_database_egress_cidr_rules : rule.description => rule }
  type              = "egress"
  security_group_id = aws_security_group.rds_database.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "rds_egress_sg" {
  for_each                 = { for rule in var.rds_database_egress_sg_rules : rule.description => rule }
  type                     = "egress"
  security_group_id        = aws_security_group.rds_database.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}
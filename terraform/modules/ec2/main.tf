data "aws_vpc" "default" {
  default = true
}

locals {
  selected_vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}

resource "tls_private_key" "generated" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  count      = var.create_ssh_key ? 1 : 0
  key_name   = "${var.name}-key"
  public_key = tls_private_key.generated[0].public_key_openssh
}

resource "local_file" "ssh_private_key" {
  count           = var.create_ssh_key && var.private_key_path != "" ? 1 : 0
  content         = tls_private_key.generated[0].private_key_pem
  filename        = var.private_key_path
  file_permission = "0600"
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip
  key_name             = var.create_ssh_key ? aws_key_pair.generated[0].key_name : (var.key_name != "" ? var.key_name : null)
  iam_instance_profile = var.iam_instance_profile_name
  user_data            = null

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
  }

  tags = merge({
    Name = var.name
  }, var.tags)
}

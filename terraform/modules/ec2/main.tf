data "aws_vpc" "default" {
  default = true
}

locals {
  selected_vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [local.selected_vpc_id]
  }
}

locals {
  selected_subnet_id = var.subnet_id != "" ? var.subnet_id : data.aws_subnets.default.ids[0]
}

data "aws_subnet" "selected" {
  id = local.selected_subnet_id
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.selected_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name != "" ? var.key_name : null
  iam_instance_profile        = var.iam_instance_profile_name
  user_data                   = var.ssh_public_key != "" ? "#cloud-config\nssh_authorized_keys:\n  - ${var.ssh_public_key}\n" : null

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
  }

}

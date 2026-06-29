locals {
  ansible_inventory_host_line = "${module.ec2.public_ip} ansible_user=${var.ssh_user}${var.private_key_path != "" ? " ansible_ssh_private_key_file=${var.private_key_path}" : ""}"
  ansible_inventory_content = <<EOF
[demo]
${local.ansible_inventory_host_line}

[demo:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory/inventory.ini"
  content  = local.ansible_inventory_content
}

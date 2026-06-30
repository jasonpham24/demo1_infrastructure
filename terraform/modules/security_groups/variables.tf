variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "The CIDR blocks to allow SSH access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_instance_ingress_cidr_rules" {
  description = "EC2 ingress rules using cidr_blocks"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "ec2_instance_ingress_sg_rules" {
  description = "EC2 ingress rules using source_security_group_id"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
  }))
  default = []
}

variable "ec2_instance_egress_cidr_rules" {
  description = "EC2 egress rules using cidr_blocks"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "ec2_instance_egress_sg_rules" {
  description = "EC2 egress rules using source_security_group_id"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
  }))
  default = []
}

variable "rds_database_ingress_cidr_rules" {
  description = "RDS ingress rules using cidr_blocks"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "rds_database_ingress_sg_rules" {
  description = "RDS ingress rules using source_security_group_id"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
  }))
  default = []
}

variable "rds_database_egress_cidr_rules" {
  description = "RDS egress rules using cidr_blocks"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { description = "Allow all outbound", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

variable "rds_database_egress_sg_rules" {
  description = "RDS egress rules using source_security_group_id"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

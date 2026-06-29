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

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

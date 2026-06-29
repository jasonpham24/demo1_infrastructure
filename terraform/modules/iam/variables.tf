variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "iam"
}

variable "assume_role_policy_json" {
  description = "JSON policy for the EC2 assume role"
  type        = string
}

variable "ec2_policy_json" {
  description = "JSON policy for the EC2 instance"
  type        = string
}

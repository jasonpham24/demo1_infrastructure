variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "ec2-bastion"
}

variable "ami_id" {
  description = "AMI id to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "VPC ID where the EC2 security group will be created (optional)"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
  default     = ""
}


variable "key_name" {
  description = "Existing EC2 key pair name (optional)."
  type        = string
  default     = ""
}

variable "create_ssh_key" {
  description = "Create a new SSH key pair and use it for the EC2 instance"
  type        = bool
  default     = false
}

variable "private_key_path" {
  description = "Local path where the generated private key will be written"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instance"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the EC2 instance"
  type        = string
  default     = ""
}

variable "ebs_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}

variable "ebs_volume_type" {
  description = "The type of the EBS volume"
  type        = string
  default     = "gp3"
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "default_vpc_id" {
  description = "The ID of the default VPC, passed from the root module."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

variable "ssh_key_rsa_bits" {
  description = "The number of bits in the RSA key for the generated SSH key pair"
  type        = number
  default     = 4096
}

variable "ssh_private_key_file_permission" {
  description = "File permission for the generated SSH private key file"
  type        = string
  default     = "0600"
}

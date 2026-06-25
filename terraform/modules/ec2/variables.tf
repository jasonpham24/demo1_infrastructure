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


variable "availability_zone" {
  description = "AZ for the instance (optional)"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Existing EC2 key pair name (optional). If empty, user data will accept an ssh public key via `ssh_public_key`."
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key content to provision for the default admin user (cloud-init authorized_key)."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR ranges allowed to SSH to the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_monitoring_ports" {
  description = "Expose Grafana/Prometheus/N8n ports in the security group"
  type        = bool
  default     = true
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the EC2 instance"
  type        = string
  default     = null
}

variable "ebs_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

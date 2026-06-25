variable "application_name" {
  description = "Elastic Beanstalk application name"
  type        = string
}

variable "environment_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
}

variable "solution_stack_name" {
  description = "Elastic Beanstalk solution stack / platform"
  type        = string
}

variable "application_version_label" {
  description = "Application version label used by Elastic Beanstalk"
  type        = string
  default     = ""
}

variable "application_version_bucket" {
  description = "S3 bucket containing the Elastic Beanstalk application version"
  type        = string
  default     = ""
}

variable "application_version_key" {
  description = "S3 object key for the Elastic Beanstalk application version"
  type        = string
  default     = ""
}

variable "environment_instance_type" {
  description = "Instance type for the Elastic Beanstalk environment"
  type        = string
  default     = "t3.small"
}

variable "environment_tier" {
  description = "Elastic Beanstalk environment tier"
  type        = string
  default     = "WebServer"
}

variable "tags" {
  description = "Tags to apply to Elastic Beanstalk resources"
  type        = map(string)
  default     = {}
}

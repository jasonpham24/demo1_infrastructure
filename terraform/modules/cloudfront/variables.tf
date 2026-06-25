variable "enabled" {
  description = "Enable CloudFront distribution creation"
  type        = bool
  default     = false
}

variable "name" {
  description = "Base name for the CloudFront distribution"
  type        = string
}

variable "bucket_id" {
  description = "The S3 bucket name used as the CloudFront origin"
  type        = string
}

variable "aliases" {
  description = "Alternate domain names for the distribution"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = "Default root object served by CloudFront"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

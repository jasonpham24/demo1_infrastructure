variable "zone_id" {
  description = "Cloudflare zone ID where DNS records should be created"
  type        = string
  default     = ""
}

variable "zone_name" {
  description = "Cloudflare zone name used to lookup the zone ID"
  type        = string
  default     = ""
}

variable "record_name" {
  description = "Name of the DNS record to create"
  type        = string
  default     = ""
}

variable "record_type" {
  description = "Type of the DNS record"
  type        = string
  default     = "CNAME"
}

variable "record_value" {
  description = "Target value for the DNS record"
  type        = string
  default     = ""
}

variable "ttl" {
  description = "TTL for the DNS record"
  type        = number
  default     = 1
}

variable "proxied" {
  description = "Whether Cloudflare should proxy the DNS record"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the Cloudflare module"
  type        = map(string)
  default     = {}
}

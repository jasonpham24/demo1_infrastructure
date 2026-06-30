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

variable "cloudflare_zone_id_from_data_source" {
  description = "The ID of the Cloudflare zone, obtained from a data source in the root module."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the Cloudflare module"
  type        = map(string)
  default     = {}
}

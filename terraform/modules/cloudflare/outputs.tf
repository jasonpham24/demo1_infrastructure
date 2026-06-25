output "record_name" {
  description = "The created Cloudflare DNS record name"
  value       = try(cloudflare_dns_record.this[0].name, null)
}

output "record_value" {
  description = "The target value of the Cloudflare DNS record"
  value       = try(cloudflare_dns_record.this[0].content, null)
}

output "record_id" {
  description = "The Cloudflare DNS record ID"
  value       = try(cloudflare_dns_record.this[0].id, null)
}

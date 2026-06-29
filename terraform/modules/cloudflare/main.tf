resource "cloudflare_record" "this" {
  count = var.record_name != "" && var.record_value != "" && (var.zone_id != "" || var.zone_name != "") ? 1 : 0

  zone_id = var.zone_id != "" ? var.zone_id : var.cloudflare_zone_id_from_data_source
  name    = var.record_name
  type    = var.record_type
  value   = var.record_value
  ttl     = var.ttl
  proxied = var.proxied
}

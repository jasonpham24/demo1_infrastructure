data "cloudflare_zone" "zone" {
  count = var.enabled && var.zone_id == "" && var.zone_name != "" ? 1 : 0

  filter = {
    name = var.zone_name
  }
}

resource "cloudflare_dns_record" "this" {
  count = var.enabled && var.record_name != "" && var.record_value != "" && (var.zone_id != "" || var.zone_name != "") ? 1 : 0

  zone_id = var.zone_id != "" ? var.zone_id : data.cloudflare_zone.zone[0].id
  name    = var.record_name
  type    = var.record_type
  content = var.record_value
  ttl     = var.ttl
  proxied = var.proxied
}

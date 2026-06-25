data "cloudflare_zones" "zone" {
  count = var.zone_id == "" && var.zone_name != "" ? 1 : 0

  filter {
    name = var.zone_name
  }
}

resource "cloudflare_record" "this" {
  count = var.record_name != "" && var.record_value != "" && (var.zone_id != "" || var.zone_name != "") ? 1 : 0

  zone_id = var.zone_id != "" ? var.zone_id : data.cloudflare_zones.zone[0].zones[0].id
  name    = var.record_name
  type    = var.record_type
  value   = var.record_value
  ttl     = var.ttl
  proxied = var.proxied
}

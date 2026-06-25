output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = try(aws_cloudfront_distribution.this.domain_name, null)
}

output "origin_access_identity" {
  description = "CloudFront origin access identity identifier"
  value       = try(aws_cloudfront_origin_access_identity.this.id, null)
}

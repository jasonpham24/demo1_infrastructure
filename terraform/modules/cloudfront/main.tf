resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${var.name}"
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontReadOnly"
        Effect = "Allow"
        Principal = {
          AWS = [aws_cloudfront_origin_access_identity.this.iam_arn]
        }
        Action   = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::${var.bucket_id}/*"]
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "CloudFront distribution for ${var.name}"
  price_class         = var.price_class
  aliases             = var.aliases
  default_root_object = var.default_root_object

  origin {
    domain_name = "${var.bucket_id}.s3.amazonaws.com"
    origin_id   = "${var.name}-origin"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.this.id}"
    }
  }

  default_cache_behavior {
    target_origin_id       = "${var.name}-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

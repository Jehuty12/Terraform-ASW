# Cloudfront Distribution creation
resource "aws_cloudfront_distribution" "cdn" {
  http_version = "http2and3"
  # S3 Bucket Origin for Static Content
  origin {
    domain_name = var.s3_bucket_domain
    origin_id   = "S3-Frontend"

    s3_origin_config {
      origin_access_identity = var.cloudfront_oai_identity_path
    }

    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "https-only"
    #   origin_ssl_protocols   = ["TLSv1.2"]
    # }
  }

  # API Gateway Origin for Backend Requests
  origin {
    domain_name = var.api_gateway_domain
    origin_id   = "API-Backend"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  # Default Cache Behavior (Static Content - S3)
  default_cache_behavior {
    target_origin_id       = "S3-Frontend"
    viewer_protocol_policy  = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # API Cache Behavior (API Gateway)
  ordered_cache_behavior {
    path_pattern           = "/${var.api_stage_name}/*"  # Directs all /${api_stage_name}/* requests to the API Gateway
    target_origin_id       = "API-Backend"
    viewer_protocol_policy  = "https-only"
    allowed_methods        = ["HEAD", "GET", "POST", "OPTIONS", "PUT", "DELETE", "PATCH"]
    cached_methods         = ["GET", "HEAD"]

    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}

  # Viewer Certificate for HTTP (or HTTPS if switched)
  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
  aliases = [ var.paas_domain_name ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# Create an alias that will point to the cloudfront distribution domain name
resource "aws_route53_record" "alias" {
  zone_id                  = var.zone_id
  name                     = var.paas_domain_name
  type                     = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}





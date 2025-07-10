# S3 bucket domain name, redirection for static content
variable "s3_bucket_domain" {
  description = "The domain name of the S3 bucket (CloudFront origin)"
  type        = string
}

# API Gateway domain name, redirection for dynamic content
variable "api_gateway_domain" {
  description = "The domain name of the API Gateway (CloudFront origin)"
  type        = string
}

variable "cache_policy_id" {
  description = "Cache policy ID for S3 content"
  type        = string
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"  # AWS Managed CachingOptimized policy
}

variable "api_cache_policy_id" {
  description = "Cache policy ID for API requests"
  type        = string
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"  # AWS Managed No-Caching policy
}

variable "acm_certificate_arn" {
  description = "The ACM certifcate ARN"
  type = string
}

variable "paas_domain_name" {
  description = "The domain name of the PAAS web application"
  type = string
}

variable "zone_id" {
    description = "The root domain name without any subdomain id"
    type = string
}

variable "cloudfront_oai_identity_path" {
  description = "The origin access identity to let only cloudfront access the S3"
  type = string
}

variable "api_stage_name" {
  description = "API gateway stage name"
  type = string
}
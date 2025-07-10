output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_front_application.bucket
}

# S3 bucket domain name to be accessed to access to static content files
output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.my_front_application.bucket_regional_domain_name
}

output "cloudfront_oai_identity_path" {
  description = "The origin access identity to let only cloudfront access the S3"
  value = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}
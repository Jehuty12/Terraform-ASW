output "api_domain" {
  description = "api domain name"
  value       = module.api_gateway.api_endpoint
}

output "s3_domain" {
  description = "s3 domain name"
  value       = module.s3.bucket_domain_name
}
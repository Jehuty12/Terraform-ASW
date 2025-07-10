# AWS
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "The aws profile in ~/.aws/credentials"
  type        = string
  default     = "cloud_901"
}

# S3
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static frontend hosting"
  type        = string
  default     = "s3-bucket-paas-80497159158518"
}

# API Gateway
variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "my_api"
}

# DynamoDB
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for user data"
  type        = string
  default     = "user_data"
}

# CloudFront
variable "cloudfront_origin_domain" {
  description = "Domain name for CloudFront origin"
  type        = string
  default     = "CloudFront domain origin"
}

variable "cache_policy_id" {
  description = "ID of the CloudFront cache policy to use"
  type        = string
  default     = "658327ea-f89d-4fab-a063-55036e7b1e07"
}

# Cognito
variable "cognito_user_pool_name" {
  description = "Name of the Cognito user pool"
  type        = string
  default     = "user_pool"
}

variable "cognito_client_name" {
  description = "Name of the Cognito app client"
  type        = string
  default     = "app_client"
}

variable "paas_domain_name" {
  description = "The domain name of the PAAS web application"
  type        = string
  default     = "paas.cloud-901.click"
}

variable "zone_id" {
  description = "The root domain name without any subdomain id"
  type        = string
  default     = "Z00142181I8L43QHOWJX0"
}

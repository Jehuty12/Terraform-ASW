variable "bucket_name" {
  description = "Name of the S3 bucket for frontend hosting"
  type        = string
}

# TO BE DELETED IN NEXT UPDATES
variable "apiGatewayUrl" {
  type = string
}

# TO BE DELETED IN NEXT UPDATES
variable "dynamoDBTableName" {
  type = string
}

variable "region" {
  type = string
}

variable "userPoolId" {
  type = string
}

variable "userPoolWebClientId" {
  type = string
}

variable "api_stage_name" {
  description = "API gateway stage name"
  type        = string
}
variable "paas_domain_name" {
  description = "Domain name for the PAAS"
  type        = string
}

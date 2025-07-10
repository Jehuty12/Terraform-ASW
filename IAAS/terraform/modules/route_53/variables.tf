variable "iaas_domain_name" {
  description = "The domain name of the PAAS web application"
  type = string
}

variable "zone_id" {
    description = "The root domain name without any subdomain id"
    type = string
}

variable "aws_profile" {
  description = "The aws profile in ~/.aws/credentials"
  type = string
}
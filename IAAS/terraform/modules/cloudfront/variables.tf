# variable "ec2_domain_name" {
#   description = "The public DNS or domain name of the EC2 instance."
#   type        = string
# }

variable "origin_id" {
  description = "The origin ID for the CloudFront distribution."
  type        = string
  default     = "ALB-web-server"
}

variable "alb_domain_name" {
  description = "Name of the ALB"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ACM certifcate ARN"
  type = string
}

variable "iaas_domain_name" {
  description = "The domain name of the PAAS web application"
  type = string
}

variable "zone_id" {
    description = "The root domain name without any subdomain id"
    type = string
}
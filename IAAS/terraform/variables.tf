variable "iaas_domain_name" {
  description = "The domain name of the PAAS web application"
  default = "iaas.cloud-901.click"
  type = string
}

variable "aws_profile" {
  description = "The aws profile in ~/.aws/credentials"
  type = string
}

variable "zone_id" {
    description = "The root domain name without any subdomain id"
    type = string
    default = "Z00142181I8L43QHOWJX0"
}

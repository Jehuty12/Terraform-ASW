provider "aws" {
    alias = "virginia"
    region = "us-east-1"
    profile = var.aws_profile
    default_tags {
    tags = {
      Workspace = "${terraform.workspace}"
      Application_Type = "PAAS"
    }
  }
}

# Certificate creation for the PAAS domain name, to let CloudFront access it need to be created in us-east-1
resource "aws_acm_certificate" "certificate_paas" {
    domain_name = var.paas_domain_name
    validation_method = "DNS"
    provider = aws.virginia
}

resource "aws_route53_record" "paas_certificate_record" {
    for_each = {
      for dvo in aws_acm_certificate.certificate_paas.domain_validation_options : dvo.domain_name => {
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
      }
    }

    allow_overwrite = true
    name = each.value.name
    records = [
        each.value.record
    ]
    ttl = 300
    type = each.value.type
    zone_id = var.zone_id
}

# resource "aws_acm_certificate_validation" "acm-validation" {
#   certificate_arn         = aws_acm_certificate.certificate_paas.arn
#   validation_record_fqdns = [for record in aws_route53_record.paas_certificate_record : record.fqdn]
# }
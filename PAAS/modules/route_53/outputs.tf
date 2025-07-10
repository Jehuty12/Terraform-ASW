output "acm_certificate_arn" {
  description = "The ACM certifcate ARN"
  value       = aws_acm_certificate.certificate_paas.arn
}
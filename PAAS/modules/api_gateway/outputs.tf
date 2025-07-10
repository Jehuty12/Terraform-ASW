# The API endpoint to be called by CloudFront to manage backend functions
output "api_endpoint" {
  value       = "${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com"
  description = "The full invoke URL for the API Gateway in the prod stage."
}

output "api_stage_name" {
  value = aws_api_gateway_deployment.api_gateway_deployment.stage_name
  description = "API gateway stage name"
}
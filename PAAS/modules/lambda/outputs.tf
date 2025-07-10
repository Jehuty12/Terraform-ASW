# Lambda ARN
output "get_arn" {
  description = "The ARN of the Lambda GET function"
  value       = aws_lambda_function.get_lambda.invoke_arn
}

output "post_arn" {
  description = "The ARN of the Lambda POST function"
  value       = aws_lambda_function.post_lambda.invoke_arn
}


output "delete_arn" {
  description = "The ARN of the Lambda DELETE function"
  value       = aws_lambda_function.delete_lambda.invoke_arn
}


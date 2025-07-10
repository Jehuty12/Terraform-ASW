variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "get_arn" {
  description = "The ARN of the Lambda GET function"
  type = string
}

variable "post_arn" {
  description = "The ARN of the Lambda POST function"
  type = string
}

variable "delete_arn" {
  description = "The ARN of the Lambda DELETE function"
  type = string
}

variable "aws_region" {
  description = "The target AWS region"
  type = string
}

variable "user_pool_arn" {
  description = "Cognito user pool arn"
  type = string
}

output "iam_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.role-allow-cloudwatch-agent.name
}

output "iam_instance_profile" {
  description = "The name of the IAM instance profile."
  value       = aws_iam_instance_profile.profile-iaas-ec2.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.role-allow-cloudwatch-agent.arn
}

variable "public_subnets" {
  description = "List of public subnets for the ASG"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "health_check_grace" {
  description = "Grace period for health check"
  type        = number
}

variable "alb_target_group_arn" {
  description = "The ARN of the target group associated with the ALB"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}


variable "asg_name" {
  description = "Name of the ALB"
  type        = string
}

variable "alb_sg_id" {
  description = "The Security Group ID of the ALB"
  type        = string
}


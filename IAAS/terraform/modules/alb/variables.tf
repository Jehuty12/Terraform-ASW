variable "public_subnets" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

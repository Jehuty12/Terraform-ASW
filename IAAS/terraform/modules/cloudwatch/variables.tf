variable "dashboard_name" {
    description = "The name of the dashboard to create containing EC2 and applicatives metrics and logs."
    type        = string
}

variable "ec2_instance_id" {
    description = "The unique identifier 'instance_id of the EC2 instance."
    type        = string
}
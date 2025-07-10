#Security group ASG
resource "aws_security_group" "asg_sg" {
  name   = "${var.asg_name}-sg"
  vpc_id = var.vpc_id

  # Autoriser uniquement les connexions de l'ALB sur le port 80 en input
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # Autoriser toutes les connexions en output
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Création du Launch Template d'EC2 pour l'ASG
resource "aws_launch_template" "lt" {
  name_prefix   = "${terraform.workspace}-my-launch-template"
  image_id      = var.instance_ami
  instance_type = var.instance_type


  user_data = base64encode(data.template_file.user_data.rendered)
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.asg_sg.id]
  }
}

#Utilisation du script User Data
data "template_file" "user_data" {
  template = <<EOF
#!/bin/bash
# Exemples de commandes à exécuter au démarrage
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
EOF
}

#Création de l'ASG
resource "aws_autoscaling_group" "asg" {
  desired_capacity         = var.desired_capacity
  max_size                 = var.max_size
  min_size                 = var.min_size
  health_check_type        = "EC2"
  vpc_zone_identifier      = var.public_subnets
  health_check_grace_period = var.health_check_grace

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  #Connexion à l'ALB via le Target Group
  target_group_arns = [var.alb_target_group_arn]
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_up" {
  alarm_name = "${terraform.workspace}-asg-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_down" {
  alarm_name = "${terraform.workspace}-asg-cpu-alarm-down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "20"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}


#Autoscaling Policy pour Scale Up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.asg.name
}

#Autoscaling Policy pour Scale Down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.asg.name
}

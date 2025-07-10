resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
        {
            "height": 7,
            "width": 8,
            "y": 7,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", var.ec2_instance_id ]
                ],
                "region": "eu-west-1",
                "title": "CPU usage (%)"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "## EC2 hardware metrics",
                "background": "solid"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 14,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "## Applicative logs",
                "background": "solid"
            }
        },
        {
            "height": 7,
            "width": 8,
            "y": 7,
            "x": 8,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "CWAgent", "mem_used_percent", "InstanceId", var.ec2_instance_id, "ImageId", "ami-0fed63ea358539e44", "InstanceType", "t2.micro" ]
                ],
                "region": "eu-west-1",
                "title": "RAM usage (%)"
            }
        },
        {
            "height": 7,
            "width": 8,
            "y": 7,
            "x": 16,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "CWAgent", "disk_used_percent", "InstanceId", var.ec2_instance_id ]
                ],
                "region": "eu-west-1",
                "title": "DISK usage (%)"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 1,
            "x": 8,
            "type": "metric",
            "properties": {
                "view": "gauge",
                "metrics": [
                    [ "CWAgent", "mem_used_percent", "InstanceId", var.ec2_instance_id, "ImageId", "ami-0fed63ea358539e44", "InstanceType", "t2.micro" ]
                ],
                "region": "eu-west-1",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#b2df8d",
                            "label": "Untitled annotation",
                            "value": 70,
                            "fill": "above"
                        },
                        {
                            "color": "#f89256",
                            "label": "Untitled annotation",
                            "value": 80,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Untitled annotation",
                            "value": 90,
                            "fill": "above"
                        },
                        [
                            {
                                "color": "#2ca02c",
                                "label": "Untitled annotation",
                                "value": 70
                            },
                            {
                                "value": 0,
                                "label": "Untitled annotation"
                            }
                        ]
                    ]
                },
                "title": "RAM usage (%)"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 1,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "CWAgent", "disk_used_percent", "InstanceId", var.ec2_instance_id, { "region": "eu-west-1" } ]
                ],
                "view": "gauge",
                "region": "eu-west-1",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#b2df8d",
                            "label": "Untitled annotation",
                            "value": 70,
                            "fill": "above"
                        },
                        {
                            "color": "#f89256",
                            "label": "Untitled annotation",
                            "value": 80,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Untitled annotation",
                            "value": 90,
                            "fill": "above"
                        },
                        [
                            {
                                "color": "#2ca02c",
                                "label": "Untitled annotation",
                                "value": 70
                            },
                            {
                                "value": 0,
                                "label": "Untitled annotation"
                            }
                        ]
                    ]
                },
                "period": 300,
                "stat": "Average",
                "title": "DISK usage (%)"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 1,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", var.ec2_instance_id ]
                ],
                "view": "gauge",
                "region": "eu-west-1",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#b2df8d",
                            "label": "Untitled annotation",
                            "value": 70,
                            "fill": "above"
                        },
                        {
                            "color": "#f89256",
                            "label": "Untitled annotation",
                            "value": 80,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Untitled annotation",
                            "value": 90,
                            "fill": "above"
                        },
                        [
                            {
                                "color": "#2ca02c",
                                "label": "Untitled annotation",
                                "value": 70
                            },
                            {
                                "value": 0,
                                "label": "Untitled annotation"
                            }
                        ]
                    ]
                },
                "period": 300,
                "stat": "Average",
                "title": "CPU usage (%)"
            }
        }
    ]
  })
}
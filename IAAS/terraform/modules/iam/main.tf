# IAM Policies for CloudWatch and EC2
data "aws_iam_policy" "policy-cloudwatch-agent-ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "policy-cloudwatch-agent-server" {
  name = "CloudWatchAgentServerPolicy"
}

# IAM Role to allow EC2 to communicate with CloudWatch
resource "aws_iam_role" "role-allow-cloudwatch-agent" {
  name = "${terraform.workspace}-role-allow-cloudwatch-agent"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM policies to the IAM Role
resource "aws_iam_role_policy_attachment" "attach-cloudwatch-agent-ssm" {
  role       = aws_iam_role.role-allow-cloudwatch-agent.name
  policy_arn = data.aws_iam_policy.policy-cloudwatch-agent-ssm.arn
}

resource "aws_iam_role_policy_attachment" "attach-cloudwatch-agent-server" {
  role       = aws_iam_role.role-allow-cloudwatch-agent.name
  policy_arn = data.aws_iam_policy.policy-cloudwatch-agent-server.arn
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "profile-iaas-ec2" {
  name = "${terraform.workspace}-profile-iaas-ec2"
  role = aws_iam_role.role-allow-cloudwatch-agent.name
}

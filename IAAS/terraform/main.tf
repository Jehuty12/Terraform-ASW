terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = var.aws_profile
  default_tags {
    tags = {
      Workspace = "${terraform.workspace}"
      Application_Type = "IAAS"
    }
  }
}

# module security {
#     source = "./modules/ec2/security"
#     name = "security-group-iaas-v2"
# }

# module iam {
#     source = "./modules/iam"
# }

# module ec2 {
#     source = "./modules/ec2/ec2"
#     ami_id = var.ami_id
#     instance_type = var.instance_type
#     ssh_key = var.path_to_ssh_key
#     security_group = module.security.id
#     iam_instance_profile = module.iam.iam_instance_profile
# }

# module cloudwatch {
#     source ="./modules/cloudwatch"
#     dashboard_name = "${terraform.workspace}-dashboard-iaas"
#     ec2_instance_id = module.alb.alb_dns_name
# }

data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


module "route53" {
  source = "./modules/route_53"
  zone_id = var.zone_id
  aws_profile = var.aws_profile
  iaas_domain_name = "${terraform.workspace}-${var.iaas_domain_name}"
}


module cloudfront {
  source = "./modules/cloudfront"
  alb_domain_name = module.alb.alb_dns_name
  origin_id       = "ALB-web-server"
  iaas_domain_name = "${terraform.workspace}-${var.iaas_domain_name}"
  acm_certificate_arn = module.route53.acm_certificate_arn
  zone_id = var.zone_id
}

#Application Load-Balancer
module "alb" {
  source           = "./modules/alb"
  public_subnets   = data.aws_subnets.default_vpc_subnets.ids
  alb_name         = "${terraform.workspace}-my-app-alb"
  target_group_name = "${terraform.workspace}-my-app-tg"
  listener_port    = 80
  vpc_id = data.aws_vpc.default.id
}

#Auto-Scalling Group
module "asg" {
  source              = "./modules/asg"
  public_subnets      = data.aws_subnets.default_vpc_subnets.ids
  instance_type       = "t2.micro"
  asg_name            = "${terraform.workspace}-my-app-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  health_check_grace  = 300
  instance_ami        = "ami-00385a401487aefa4"
  alb_target_group_arn = module.alb.alb_target_group_arn
  alb_sg_id = module.alb.alb_sg_id
  vpc_id = data.aws_vpc.default.id
}
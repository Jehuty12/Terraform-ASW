provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      Workspace = "${terraform.workspace}"
      Application_Type = "PAAS"
    }
  }
}

module "route_53" {
  source           = "./modules/route_53"
  aws_profile      = var.aws_profile
  zone_id          = var.zone_id
  paas_domain_name = "${terraform.workspace}-${var.paas_domain_name}"
}

# S3 Module
module "s3" {
  source              = "./modules/s3"
  bucket_name         = "${terraform.workspace}-${var.s3_bucket_name}"
  dynamoDBTableName   = module.dynamodb.table_name
  apiGatewayUrl       = module.api_gateway.api_endpoint
  region              = var.aws_region
  userPoolId          = module.cognito.user_pool_id
  userPoolWebClientId = module.cognito.user_pool_client_id
  api_stage_name      = module.api_gateway.api_stage_name
  paas_domain_name    = "${terraform.workspace}-${var.paas_domain_name}"
}

# Lambda Module
module "lambda" {
  source              = "./modules/lambda"
  dynamodb_table_name = module.dynamodb.table_name
}


# API Gateway Module
module "api_gateway" {
  source        = "./modules/api_gateway"
  api_name      = "${terraform.workspace}-${var.api_name}"
  get_arn       = module.lambda.get_arn
  post_arn      = module.lambda.post_arn
  delete_arn    = module.lambda.delete_arn
  aws_region    = var.aws_region
  user_pool_arn = module.cognito.user_pool_arn
}

# DynamoDB Module
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "${terraform.workspace}-${var.dynamodb_table_name}"
}

# CloudFront Module
module "cloudfront" {
  source                       = "./modules/cloudfront"
  s3_bucket_domain             = module.s3.bucket_domain_name
  cache_policy_id              = var.cache_policy_id
  api_gateway_domain           = module.api_gateway.api_endpoint
  acm_certificate_arn          = module.route_53.acm_certificate_arn
  paas_domain_name             = "${terraform.workspace}-${var.paas_domain_name}"
  zone_id                      = var.zone_id
  cloudfront_oai_identity_path = module.s3.cloudfront_oai_identity_path
  api_stage_name               = module.api_gateway.api_stage_name
}

# Cognito Module
module "cognito" {
  source         = "./modules/cognito"
  user_pool_name = "${terraform.workspace}-${var.cognito_user_pool_name}"
  client_name    = "${terraform.workspace}-${var.cognito_client_name}"
}


# S3 bucket creation
resource "aws_s3_bucket" "my_front_application" {
  bucket = var.bucket_name

  tags = {
    Name = "Frontend Bucket"
  }
}

# Configure S3 for website hosting
resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.my_front_application.id # Reference the bucket ID here


  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# index.html creation in the S3 bucket
resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.my_front_application.id
  key          = "index.html"
  source       = "${path.module}/code/index.html"
  content_type = "text/html"
  tags = {
    Name = "Index HTML"
  }
}

# error.html creation in the S3 bucket
resource "aws_s3_bucket_object" "error_html" {
  bucket       = aws_s3_bucket.my_front_application.id
  key          = "error.html"
  source       = "${path.module}/code/error.html"
  content_type = "text/html"
  tags = {
    Name = "Error HTML"
  }
}

# index.js creation in the S3 bucket
resource "aws_s3_bucket_object" "index_js" {
  bucket       = aws_s3_bucket.my_front_application.id
  key          = "index.js"
  source       = "${path.module}/code/dist/index.js"
  content_type = "application/javascript"
  tags = {
    Name = "Index JS"
  }
}

# config.json creation in the S3 bucket to create dynamic env variables to be load in the index.js file
resource "aws_s3_bucket_object" "config_json" {
  bucket = aws_s3_bucket.my_front_application.id
  key    = "config.json"
  content = jsonencode({
    apiGatewayUrl       = var.apiGatewayUrl
    dynamoDBTableName   = var.dynamoDBTableName
    region              = var.region
    userPoolId          = var.userPoolId
    userPoolWebClientId = var.userPoolWebClientId
    apiStageName        = var.api_stage_name
    paasDomainName      = var.paas_domain_name
  })
  content_type = "application/json"
}

# resource "aws_s3_bucket_object" "index_js" {
#   bucket = aws_s3_bucket.my_front_application.id
#   key    = "package.json" 
#   source = "${path.module}/code/package.json"
#   content_type = "application/json"
#   tags = {
#     Name = "Package json"
#   }
# }


# Public access block to allow public access
resource "aws_s3_bucket_public_access_block" "frontend_bucket_access" {
  bucket                  = aws_s3_bucket.my_front_application.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Origin access identity to restrict S3 access to only cloudfront
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3"
}

# Bucket Policy to allow public read access
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.my_front_application.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.my_front_application.arn}/*"
      }
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.frontend_bucket_access
  ]
}

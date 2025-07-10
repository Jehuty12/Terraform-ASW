# Lambda function creation
resource "aws_lambda_function" "get_lambda" {
  function_name    = "${terraform.workspace}-lbd-paas-get"
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/code/get/get.zip" # Specify the zip file directly
  source_code_hash = filebase64sha256("${path.module}/code/get/get.zip")

  layers = [
    aws_lambda_layer_version.shared_layer.arn
  ]

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}

# Lambda function creation
resource "aws_lambda_function" "post_lambda" {
  function_name    = "${terraform.workspace}-lbd-paas-post"
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/code/post/post.zip" # Specify the zip file directly
  source_code_hash = filebase64sha256("${path.module}/code/post/post.zip")

  layers = [
    aws_lambda_layer_version.shared_layer.arn
  ]

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}


# Lambda function creation
resource "aws_lambda_function" "delete_lambda" {
  function_name    = "${terraform.workspace}-lbd-paas-delete"
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/code/delete/delete.zip" # Specify the zip file directly
  source_code_hash = filebase64sha256("${path.module}/code/delete/delete.zip")

  layers = [
    aws_lambda_layer_version.shared_layer.arn
  ]

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "${terraform.workspace}-lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : { "Service" : "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logging_policy" {
  name = "${terraform.workspace}-lambda-logging-policy"
  role = aws_iam_role.lambda_role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        "Resource" : "arn:aws:dynamodb:eu-west-1:183295425386:table/${terraform.workspace}-user_data"
      }
    ]
    }
  )
}
resource "aws_lambda_layer_version" "shared_layer" {
  layer_name          = "${terraform.workspace}-shared-layer"
  compatible_runtimes = ["nodejs20.x"]
  description         = "Shared Layer for common dependencies"
  filename            = "${path.module}/code/layers/sharedLayer.zip"
}

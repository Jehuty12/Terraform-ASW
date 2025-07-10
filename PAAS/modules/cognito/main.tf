# Cognito user pool (global)
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

}

# Simple user pool client for our application (specific) linked to the cognito global user pool
resource "aws_cognito_user_pool_client" "client" {
  user_pool_id           = aws_cognito_user_pool.user_pool.id
  name                   = var.client_name
  generate_secret        = false
}

# Define a sample Cognito User for testing
resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "example@example.com"
  password     = "YourSecurePassword123!"

  attributes = {
    email = "example@example.com"
  }

  lifecycle {
    ignore_changes = [password] # Optional: prevents unintended updates
  }
}

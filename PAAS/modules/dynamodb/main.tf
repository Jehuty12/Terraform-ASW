# DynamoDb table creation
resource "aws_dynamodb_table" "user_data" {
  name         = var.table_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  # attribute {
  #   name = "product"
  #   type = "S"
  # }

  # attribute {
  #   name = "price"
  #   type = "N"
  # }

  # Création de l'index secondaire global (GSI) pour "price" et "product"
  # global_secondary_index {
  #   name            = "PriceIndex"
  #   hash_key        = "price"
  #   projection_type = "ALL" # Cela inclut tous les attributs de l'élément dans l'index
  # }

  # global_secondary_index {
  #   name            = "ProductIndex"
  #   hash_key        = "product"
  #   projection_type = "ALL"
  # }


  # Activer la restauration point-in-time ( durée de rétention de 35 jours par défauts)
  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "url_storage" {
  name         = var.dynamodb_tablename
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "UserId"
  attribute {
    name = "UserId"
    type = "S"
  }
}


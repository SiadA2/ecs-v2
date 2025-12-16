resource "aws_s3_bucket" "dev" {
  bucket = "ecs-state-siad-dev"
}

resource "aws_s3_bucket_versioning" "dev" {
  bucket = aws_s3_bucket.dev.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "staging" {
  bucket = "ecs-state-siad-staging"
}

resource "aws_s3_bucket_versioning" "staging" {
  bucket = aws_s3_bucket.staging.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "prod" {
  bucket = "ecs-state-siad-prod"
}

resource "aws_s3_bucket_versioning" "prod" {
  bucket = aws_s3_bucket.prod.id
  versioning_configuration {
    status = "Enabled"
  }
}
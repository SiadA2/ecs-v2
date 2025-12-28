locals {
  environments = ["dev", "staging", "prod"]
}

resource "aws_ecr_repository" "repos" {
  for_each = toset(local.environments)
  
  name                 = "siada2/url-${each.key}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "untagged" {
  for_each = toset(local.environments)
  
  repository = aws_ecr_repository.repos[each.key].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Expire images older than 14 days"
      selection = {
        tagStatus     = "untagged"
        countType     = "sinceImagePushed"
        countUnit     = "days"
        countNumber   = 14
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "tagged" {
  for_each = toset(local.environments)
  
  repository = aws_ecr_repository.repos[each.key].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus       = "tagged"
        tagPrefixList   = ["v"]
        countType       = "imageCountMoreThan"
        countNumber     = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}

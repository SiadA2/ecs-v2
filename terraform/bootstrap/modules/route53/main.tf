resource "aws_route53_zone" "primary" {
  name = var.domain_name_prod
}

resource "aws_route53_zone" "staging" {
  name = var.domain_name_staging
}

resource "aws_route53_zone" "dev" {
  name = var.domain_name_dev
}
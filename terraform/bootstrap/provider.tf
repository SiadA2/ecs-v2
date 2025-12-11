terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.14.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "cloudflare" {
  api_token = var.api_token
}

# Create a DNS record
resource "cloudflare_dns_record" "ecs" {
  count = 4
  name = "ecs"
  zone_id = "6288cfd9804cc5a0854c0dd10d1de92a"
  ttl     = "600"
  type    = "NS"
  content = module.route53.nameservers[count.index]
}
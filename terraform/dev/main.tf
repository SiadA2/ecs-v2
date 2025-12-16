module "vpc" {
  source = "./modules/vpc"
  az_count = var.az_count
}
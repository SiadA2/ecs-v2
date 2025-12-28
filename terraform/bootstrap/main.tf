module "route53" {
  source = "./modules/route53"
}

module "s3" {
  source = "./modules/s3"
}

module "ecr" {
  source = "./modules/ecr"
}

module "iam" {
  source = "./modules/iam"
  admin_policy_arn = var.admin_policy_arn
  ecr_full_access_arn = var.ecr_full_access_arn
}
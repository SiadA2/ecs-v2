resource "aws_ecr_repository" "ecs" {
  name                 = "siada2/ecs"
  image_tag_mutability = "MUTABLE"
}
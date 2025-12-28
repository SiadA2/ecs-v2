variable "az_count" {
  default = 3
}

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "domain_name" {
  type = string
  default = "ecs.nginxsiad.com"
}

variable "app_port" {
  type = number
  default = 8080
}

variable "app_count" {
  default = 3
}

variable "dynamodb_tablename" {
  type = string
  default = "prod-table"
}

variable "environment" {
    type        = string
    default     = "prod"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default     = "338235305910.dkr.ecr.eu-west-2.amazonaws.com/siada2/url-prod:latest" 
}

variable "alb_name" {
  type    = string
  default = "prod-alb"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
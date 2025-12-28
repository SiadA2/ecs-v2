variable "az_count" {
  default = 2
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
  default = "dev.nginxsiad.com"
}

variable "app_port" {
  type = number
  default = 8080
}

variable "app_count" {
  default = 2
}

variable "dynamodb_tablename" {
  type = string
  default = "dev-table"
}

variable "environment" {
    type        = string
    default = "dev"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "338235305910.dkr.ecr.eu-west-2.amazonaws.com/siada2/url-dev:latest"
}

variable "alb_name" {
  type    = string
  default = "dev-alb"
}

variable "vpc_cidr" {
  default = "192.168.0.0/24"
}

variable "cluster_name" {
  default = "url-cluster-dev"
}

variable "cloudwatch_log_group" {
  default = "/ecs/task-def-dev"
}

variable "task_family" {
  default = "url-task-dev"
}
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
  default = "staging.nginxsiad.com"
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
  default = "staging-table"
}

variable "environment" {
    type        = string
    default     = "staging"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default     = "338235305910.dkr.ecr.eu-west-2.amazonaws.com/siada2/url-staging:latest" 
}

variable "alb_name" {
  type    = string
  default = "staging-alb"
}

variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

variable "cluster_name" {
  default = "url-cluster-staging"
}

variable "cloudwatch_log_group" {
  default = "/ecs/task-def-staging"
}

variable "task_family" {
  default = "task-def-staging"
}
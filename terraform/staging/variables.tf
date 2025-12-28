variable "az_count" {
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
}

variable "alb_name" {
  type    = string
}
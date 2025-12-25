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
}

variable "app_port" {
  type = number
}

variable "app_count" {
}

variable "dynamodb_tablename" {
  type = string
}
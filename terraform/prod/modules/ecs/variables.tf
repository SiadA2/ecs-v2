variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "338235305910.dkr.ecr.eu-west-2.amazonaws.com/siada2/ecs:latest"
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 8080

}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = 1024
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = 2048
}

variable "public_subnets_id" {
}

variable "alb_target_grp_arn" {
}

variable "ecs_security_group_id" {
}

variable "aws_region" {
    default = "eu-west-2"
}

variable "ddb_table_name" {
}

variable "private_subnets_id" {
}
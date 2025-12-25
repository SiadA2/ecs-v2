output "alb_security_group" {
  value = aws_security_group.lb.id
}

output "ecs_security_group" {
  value = aws_security_group.ecs_tasks.id
}

output "vpc_endpoint_security_group" {
  value = aws_security_group.vpc_endpoint.id
}
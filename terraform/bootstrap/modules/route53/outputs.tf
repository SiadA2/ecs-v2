output "prod-nameservers" {
  value = aws_route53_zone.primary.name_servers
}

output "dev-nameservers" {
  value = aws_route53_zone.dev.name_servers
}

output "staging-nameservers" {
  value = aws_route53_zone.staging.name_servers
}
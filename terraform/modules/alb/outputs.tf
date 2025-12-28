output "alb_target_grp_blue_arn" {
  value = aws_alb_target_group.blue.arn
}

output "alb_dns_name" {
  value = aws_alb.main.dns_name
}

output "alb_zone_id" {
  value = aws_alb.main.zone_id
}

output "alb_arn" {
  value = aws_alb.main.arn
}

output "alb_listener_arn" {
  value = [aws_alb_listener.https.arn]
}
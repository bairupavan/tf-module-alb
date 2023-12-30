output "listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}

output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}
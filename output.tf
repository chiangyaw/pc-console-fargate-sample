# output "aws_availability_zones" {
#   value       = data.aws_availability_zones.azs.names
# }

output "nlb_fqdn" {
  value       = aws_alb.main_nlb.dns_name
}
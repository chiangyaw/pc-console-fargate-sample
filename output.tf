# output "aws_availability_zones" {
#   value       = data.aws_availability_zones.azs.names
# }

output "nlb_dns_name" {
  value       = aws_alb.main_nlb.dns_name
}

output "efs_id" {
  value       = aws_efs_file_system.pc_console_fargate_efs.id
}
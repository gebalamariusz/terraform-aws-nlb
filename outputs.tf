# ------------------------------------------------------------------------------
# NLB OUTPUTS
# ------------------------------------------------------------------------------

output "nlb_id" {
  description = "ID of the NLB"
  value       = aws_lb.this.id
}

output "nlb_arn" {
  description = "ARN of the NLB"
  value       = aws_lb.this.arn
}

output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.this.dns_name
}

output "nlb_zone_id" {
  description = "Zone ID of the NLB"
  value       = aws_lb.this.zone_id
}

output "nlb_arn_suffix" {
  description = "ARN suffix of the NLB for use with CloudWatch Metrics"
  value       = aws_lb.this.arn_suffix
}

# ------------------------------------------------------------------------------
# TARGET GROUP OUTPUTS
# ------------------------------------------------------------------------------

output "target_group_arns" {
  description = "Map of target group names to ARNs"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "target_group_arn_suffixes" {
  description = "Map of target group names to ARN suffixes"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn_suffix }
}

output "target_group_names" {
  description = "Map of target group keys to names"
  value       = { for k, v in aws_lb_target_group.this : k => v.name }
}

# ------------------------------------------------------------------------------
# LISTENER OUTPUTS
# ------------------------------------------------------------------------------

output "listener_arns" {
  description = "Map of listener names to ARNs"
  value       = { for k, v in aws_lb_listener.this : k => v.arn }
}

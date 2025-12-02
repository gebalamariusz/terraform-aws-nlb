# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "name" {
  description = "Name for the NLB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where NLB will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for NLB"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# NLB CONFIGURATION
# ------------------------------------------------------------------------------

variable "internal" {
  description = "Whether the NLB is internal (true) or internet-facing (false)"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for NLB"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# TARGET GROUP CONFIGURATION
# ------------------------------------------------------------------------------

variable "target_groups" {
  description = "Map of target group configurations"
  type = map(object({
    port                   = number
    protocol               = optional(string, "TCP")
    target_type            = optional(string, "instance")
    deregistration_delay   = optional(number, 300)
    connection_termination = optional(bool, false)
    preserve_client_ip     = optional(bool, true)
    proxy_protocol_v2      = optional(bool, false)
    health_check = optional(object({
      enabled             = optional(bool, true)
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "TCP")
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
      interval            = optional(number, 30)
      path                = optional(string, "/")
      matcher             = optional(string, "200-399")
    }), {})
  }))
  default = {}
}

# ------------------------------------------------------------------------------
# LISTENER CONFIGURATION
# ------------------------------------------------------------------------------

variable "listeners" {
  description = "Map of listener configurations"
  type = map(object({
    port             = number
    protocol         = optional(string, "TCP")
    target_group_key = string
    ssl_policy       = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    certificate_arn  = optional(string, null)
  }))
  default = {}
}

# ------------------------------------------------------------------------------
# ACCESS LOGS
# ------------------------------------------------------------------------------

variable "enable_access_logs" {
  description = "Enable access logs for NLB"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket name for access logs"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 bucket prefix for access logs"
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# TAGS
# ------------------------------------------------------------------------------

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

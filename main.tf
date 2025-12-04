# ------------------------------------------------------------------------------
# LOCAL VALUES
# ------------------------------------------------------------------------------

locals {
  name_prefix = var.environment != "" ? "${var.name}-${var.environment}" : var.name

  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "terraform-aws-nlb"
  })
}

# ------------------------------------------------------------------------------
# NETWORK LOAD BALANCER
# ------------------------------------------------------------------------------

resource "aws_lb" "this" {
  name               = local.name_prefix
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  dynamic "access_logs" {
    for_each = var.enable_access_logs && var.access_logs_bucket != null ? [1] : []
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge(local.common_tags, {
    Name = local.name_prefix
  })
}

# ------------------------------------------------------------------------------
# TARGET GROUPS
# ------------------------------------------------------------------------------

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = "${local.name_prefix}-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  deregistration_delay   = each.value.deregistration_delay
  connection_termination = each.value.connection_termination
  preserve_client_ip     = each.value.preserve_client_ip
  proxy_protocol_v2      = each.value.proxy_protocol_v2

  health_check {
    enabled             = each.value.health_check.enabled
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    interval            = each.value.health_check.interval
    # Path only for HTTP/HTTPS health checks
    path    = each.value.health_check.protocol == "HTTP" || each.value.health_check.protocol == "HTTPS" ? each.value.health_check.path : null
    matcher = each.value.health_check.protocol == "HTTP" || each.value.health_check.protocol == "HTTPS" ? each.value.health_check.matcher : null
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# LISTENERS
# ------------------------------------------------------------------------------

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  # TLS configuration (optional)
  ssl_policy      = each.value.protocol == "TLS" ? each.value.ssl_policy : null
  certificate_arn = each.value.protocol == "TLS" ? each.value.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}"
  })
}

# AWS Network Load Balancer Terraform Module

[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-gebalamariusz%2Fnlb%2Faws-blue?logo=terraform)](https://registry.terraform.io/modules/gebalamariusz/nlb/aws)
[![CI](https://github.com/gebalamariusz/terraform-aws-nlb/actions/workflows/ci.yml/badge.svg)](https://github.com/gebalamariusz/terraform-aws-nlb/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/gebalamariusz/terraform-aws-nlb?display_name=tag&sort=semver)](https://github.com/gebalamariusz/terraform-aws-nlb/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.7-purple.svg)](https://www.terraform.io/)

Terraform module for AWS Network Load Balancer (NLB).

This module is designed to work seamlessly with [terraform-aws-vpc](https://github.com/gebalamariusz/terraform-aws-vpc) and [terraform-aws-subnets](https://github.com/gebalamariusz/terraform-aws-subnets) modules.

## Features

- Internal or internet-facing NLB
- Multiple target groups with configurable health checks
- TCP, UDP, and TLS listeners
- Cross-zone load balancing
- Access logging support
- Deletion protection option
- Consistent naming and tagging conventions

## Usage

### Basic usage

```hcl
module "nlb" {
  source  = "gebalamariusz/nlb/aws"
  version = "~> 1.0"

  name        = "my-app"
  environment = "prod"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.private_subnet_ids

  internal = true  # Internal NLB for VPC-only access

  target_groups = {
    "app" = {
      port        = 8080
      protocol    = "TCP"
      target_type = "instance"
      health_check = {
        protocol = "HTTP"
        path     = "/health"
        matcher  = "200"
      }
    }
  }

  listeners = {
    "app" = {
      port             = 8080
      protocol         = "TCP"
      target_group_key = "app"
    }
  }

  tags = {
    Owner = "team-platform"
  }
}
```

### TLS listener with certificate

```hcl
module "nlb" {
  source  = "gebalamariusz/nlb/aws"
  version = "~> 1.0"

  name        = "my-app"
  environment = "prod"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids

  internal = false

  target_groups = {
    "api" = {
      port        = 443
      protocol    = "TCP"
      target_type = "ip"
    }
  }

  listeners = {
    "tls" = {
      port             = 443
      protocol         = "TLS"
      target_group_key = "api"
      certificate_arn  = "arn:aws:acm:eu-west-1:123456789:certificate/xxx"
      ssl_policy       = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the NLB and related resources | `string` | n/a | yes |
| vpc_id | VPC ID where NLB will be deployed | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for NLB | `list(string)` | n/a | yes |
| internal | Whether the NLB is internal | `bool` | `true` | no |
| enable_deletion_protection | Enable deletion protection | `bool` | `false` | no |
| enable_cross_zone_load_balancing | Enable cross-zone load balancing | `bool` | `true` | no |
| enable_access_logs | Enable access logging | `bool` | `false` | no |
| access_logs_bucket | S3 bucket for access logs | `string` | `null` | no |
| target_groups | Map of target group configurations | `map(object)` | `{}` | no |
| listeners | Map of listener configurations | `map(object)` | `{}` | no |
| environment | Environment name | `string` | `""` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| nlb_id | ID of the NLB |
| nlb_arn | ARN of the NLB |
| nlb_dns_name | DNS name of the NLB |
| nlb_zone_id | Zone ID of the NLB |
| target_group_arns | Map of target group names to ARNs |
| listener_arns | Map of listener names to ARNs |

## License

MIT

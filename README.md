# terraform-aws-nlb

Terraform module for AWS Network Load Balancer (NLB).

## Features

- Internal or internet-facing NLB
- Multiple target groups with configurable health checks
- TCP, UDP, and TLS listeners
- Cross-zone load balancing
- Access logging support

## Usage

```hcl
module "nlb" {
  source  = "gebalamariusz/nlb/aws"
  version = "1.0.0"

  name        = "my-app"
  environment = "prod"

  vpc_id     = "vpc-123456"
  subnet_ids = ["subnet-abc", "subnet-def"]

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the NLB and related resources | `string` | n/a | yes |
| vpc_id | VPC ID where NLB will be deployed | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for NLB | `list(string)` | n/a | yes |
| internal | Whether the NLB is internal | `bool` | `true` | no |
| enable_deletion_protection | Enable deletion protection | `bool` | `false` | no |
| enable_cross_zone_load_balancing | Enable cross-zone load balancing | `bool` | `true` | no |
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

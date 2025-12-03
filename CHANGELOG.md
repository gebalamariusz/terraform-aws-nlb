# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-28

### Added

- Initial release of AWS NLB Terraform module
- Network Load Balancer creation (internal or internet-facing)
- Multiple target groups with configurable health checks
- Support for TCP, UDP, and TLS listeners
- TLS listener support with certificate ARN and SSL policy
- Cross-zone load balancing option
- Access logging to S3 bucket
- Deletion protection option
- Consistent naming with name prefix and environment
- Consistent tagging with `ManagedBy` and `Module` tags
- CI pipeline with terraform fmt, validate, tflint, and tfsec
- MIT License

[1.0.0]: https://github.com/gebalamariusz/terraform-aws-nlb/releases/tag/v1.0.0

# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this module, please report it responsibly:

1. **Do not** open a public GitHub issue for security vulnerabilities
2. Email the maintainer directly at: security@haitmg.pl
3. Include detailed information about the vulnerability
4. Allow reasonable time for a fix before public disclosure

## Security Best Practices

When using this module:

- Use internal NLBs (`internal = true`) when public access is not required
- Configure appropriate security groups for target instances
- Enable access logging for audit trails
- Use TLS listeners with valid certificates for encrypted traffic
- Regularly review and update security group rules
- Follow the principle of least privilege for target group access

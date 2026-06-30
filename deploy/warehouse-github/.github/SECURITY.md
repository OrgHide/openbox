# Security Policy

## Supported Versions
| Version | Supported |
|---------|-----------|
| 2.x     | ✅        |
| 1.x     | ❌        |

## Reporting a Vulnerability
Please report security issues to: security@warehouse.local

## Security Measures
1. **Authentication**: YubiKey + 2FA required
2. **Authorization**: Role-based access (Super Admin / Sub Admin)
3. **Encryption**: SSH Ed25519 keys
4. **Access Control**: Single connection limit
5. **Audit Logging**: All actions logged
6. **Backup**: Daily encrypted backups
7. **Dependabot**: Automated dependency updates
8. **Secrets Management**: No secrets in code

## Security Checklist
- [x] SSH keys generated
- [x] YubiKey configured
- [x] 2FA enabled
- [x] Dependabot active
- [x] Security scanning enabled
- [x] Audit logging enabled
- [x] Backup system active

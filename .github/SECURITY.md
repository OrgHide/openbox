# 🔐 OpenBox Security Policy

## Supported Versions
| Version | Supported |
|---------|-----------|
| 2.x     | ✅        |
| 1.x     | ❌        |

## Reporting a Vulnerability
**Contact:** security@openbox.host
**Response Time:** 24-48 hours

## Security Features
### Authentication
- ✅ YubiKey + 2FA for Super Admin
- ✅ 2FA for Sub Admins
- ✅ SSH Ed25519 keys

### Authorization
- ✅ Role-based access (Super Admin / Sub Admin)
- ✅ CODEOWNERS file for code review
- ✅ Branch protection rules

### Encryption
- ✅ SSH Ed25519 keys
- ✅ Encrypted secrets in GitHub

### Access Control
- ✅ Single connection limit
- ✅ IP whitelisting available
- ✅ Deploy keys with write access

### Monitoring
- ✅ GitHub Actions security scanning
- ✅ Dependabot alerts
- ✅ Audit logging
- ✅ Trivy vulnerability scanning

### Backup
- ✅ Daily encrypted backups
- ✅ Multi-cloud redundancy
- ✅ 30-day retention

## Security Checklist
- [x] SSH keys generated
- [x] YubiKey configured
- [x] 2FA enabled
- [x] Dependabot active
- [x] Security scanning enabled
- [x] Audit logging enabled
- [x] Backup system active
- [x] Branch protection rules
- [x] CODEOWNERS configured

## Responsible Disclosure
We take security seriously. Please report vulnerabilities privately.

## Security Contacts
- **Super Admin:** admin@openbox.host
- **Security Team:** security@openbox.host

---

**Last Updated:** July 2026

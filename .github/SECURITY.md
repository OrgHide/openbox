# 🔐 OpenBox Security Policy

## Access Control
- **Single Connection**: Only one session per user
- **IP Whitelisting**: Only approved IPs can connect
- **Device Registration**: Only registered devices allowed
- **2FA Required**: All users must use 2FA
- **YubiKey**: Super Admin requires YubiKey

## User Hierarchy
### Super Admin
- Full access to all features
- YubiKey + 2FA required
- Emergency backup access
- Can create/delete users
- Full system configuration

### Sub Admin
- Limited access
- 2FA required
- Storage access only
- File management only
- View logs only

## Security Rules
1. IP whitelist enforced
2. Device registration required
3. Single connection limit
4. Session timeout: 15 minutes
5. Max login attempts: 5
6. Lockout duration: 15 minutes

## Emergency Access
- Super Admin has emergency backup access
- SSH keys allow recovery access
- Emergency contact: admin@openbox.host

## Reporting
Report vulnerabilities: security@openbox.host

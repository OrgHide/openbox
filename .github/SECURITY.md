# 🔐 OpenBox Security Policy

## User Hierarchy

### 👑 Super Admin: OpenClose
- **User:** Charles Tanauan (Master Kanor)
- **Username:** OpenClose
- **Password:** Openpassword
- **Access:** Full emergency backup
- **Auth:** YubiKey + 2FA + Tailscale
- **Purpose:** Emergency access only
- **Permissions:** Full system control
- **Restrictions:** None (emergency only)

### 👤 Sub-Admin: Opendev
- **User:** hoopstreet (Xenia Xu)
- **Username:** Opendev
- **Password:** Masterdev
- **Access:** Daily business & development
- **Auth:** 2FA + Tailscale
- **Purpose:** Daily operations
- **Permissions:** Limited (read-only for high-risk)

## Access Control

### Super Admin Capabilities
- ✅ Full system control
- ✅ User management
- ✅ Security configuration
- ✅ Backup & restore
- ✅ Audit logs
- ✅ Delete any file
- ✅ Modify system settings
- ✅ Emergency lockdown
- ✅ Revoke access

### Sub-Admin Capabilities
- ✅ Storage access
- ✅ File management
- ✅ View logs
- ✅ Create shares
- ✅ Business operations
- ✅ Development access
- ✅ Personal management

### Sub-Admin Restrictions
- ❌ Delete recycle bin
- ❌ Delete Super Admin
- ❌ Delete entire space
- ❌ Modify system config
- ❌ Change security policy
- ❌ Delete users

## Security Measures
1. **YubiKey Required** for Super Admin
2. **2FA Required** for all users
3. **Tailscale VPN** required
4. **Device Allowlist** enforced
5. **Single Connection** limit
6. **Auto-Revoke** on compromise
7. **Read-Only** for high-risk operations
8. **Emergency Access** only for Super Admin

## Emergency Protocol
1. Super Admin logs in with YubiKey
2. Full system access granted
3. Emergency lockdown available
4. Backup restoration available
5. Full audit trail maintained

## Reporting
Report vulnerabilities: security@openbox.host
Emergency: admin@openbox.host

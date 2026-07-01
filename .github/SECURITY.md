# 🔐 OpenBox Security Policy - Maximum Security

## Network Security
- **Tailscale Required**: All connections must go through Tailscale
- **Single Port**: Only port 2232 exposed
- **Private IP**: All traffic uses Tailscale's private network
- **No Public IP**: No public internet exposure

## Device Security
- **Device Allowlist**: Only approved devices can connect
- **Device Fingerprinting**: Unique device identification
- **MAC Binding**: Device MAC address validation
- **Clone Detection**: Blocks duplicate devices

## Access Control
- **Super Admin**: Emergency access only (YubiKey + Tailscale)
- **Sub Admin**: Daily operations (2FA + Tailscale)
- **Role-Based Access**: Granular permissions
- **Single Connection**: One session per user

## Security Features
- ✅ Tailscale VPN required
- ✅ Single port (2232) only
- ✅ Device fingerprinting
- ✅ MAC binding
- ✅ Clone detection
- ✅ IP allowlist
- ✅ Auto-revoke on compromise
- ✅ Super Admin emergency access
- ✅ Role-based access control

## Emergency Access
- Super Admin has emergency backup access
- YubiKey + Tailscale required
- Emergency contact: admin@openbox.host

## Reporting
Report vulnerabilities: security@openbox.host

# 📦 OpenBox - Unified Storage Warehouse

**Version:** 2.0.0  
**Security Level:** Maximum  
**Status:** Production Ready  
**Repository:** https://github.com/OrgHide/openbox

## 🎯 Overview
Enterprise-grade multi-cloud storage warehouse with military-grade security for solo entrepreneurs and developers.

## 🔐 Security Features
- **Authentication**: YubiKey + 2FA required
- **Authorization**: Super Admin / Sub Admin hierarchy
- **Encryption**: SSH Ed25519 keys, AES-256 at rest
- **Network**: IP whitelisting, rate limiting, DDoS protection
- **Monitoring**: 24/7 real-time, intrusion detection, malware scanning
- **Access**: Single connection limit, session timeout
- **Backup**: Daily encrypted backups with 30-day retention

## 🚀 Quick Start

### Local Development
```bash
# Clone and setup
git clone https://github.com/OrgHide/openbox.git
cd openbox
./scripts/setup.sh

# Start services
./scripts/start.sh

# Access WebUI
http://localhost:5244
```

Production Deployment (Northflank)

```bash
# Automated via GitHub Actions
# Push to main branch triggers deployment

# Or manual deployment
./scripts/deploy_northflank.sh
```

🔗 Access Points

Service URL Credentials
WebUI https://openbox.northflank.com admin / MasterPassword
WebDAV https://openbox.northflank.com:8080 admin / MasterPassword
SSH openbox.northflank.com:8022 admin / MasterPassword

☁️ Connected Clouds

· Google Drive: 3 accounts (gdrive1, gdrive2, gdrive3)
· Dropbox: 1 account (dropbox1)
· OneDrive: 1 account (onedrive1)
· Local: Android A5 device

📁 Storage Structure

```
OpenBox/
├── configs/          # Configuration files
├── scripts/          # Utility scripts
├── data/             # Storage data
├── logs/             # Application logs
├── deploy/           # Deployment files
└── security/         # Security configurations
```

🛡️ Security Compliance

· ✅ YubiKey + 2FA
· ✅ SSH Ed25519 keys
· ✅ IP Whitelisting
· ✅ Rate Limiting
· ✅ TLS 1.3
· ✅ Data Encryption
· ✅ Real-time Monitoring
· ✅ Intrusion Detection
· ✅ Malware Scanning
· ✅ Daily Backups

🤖 AI Integration

· OpenRouter AI ready
· MCP server on port 5245
· Automated organization
· Smart search

📦 Backup Strategy

· Daily encrypted backups
· Multi-cloud redundancy
· 30-day retention
· Automated verification

🔗 Links

· GitHub: https://github.com/OrgHide/openbox
· Documentation: https://docs.openbox.host
· Northflank: https://openbox.northflank.com

👥 Team

· Super Admin: master-kanor (Charles Tanauan)
· Security Team: security@openbox.host

---

Made with ❤️ for Solo Entrepreneurs
Security First | Privacy Always 🔒

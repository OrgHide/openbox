# Storage Warehouse - Professional Setup

## Overview
Multi-cloud storage warehouse for solo entrepreneurs and developers.

## Features
- Google Drive, Dropbox, OneDrive integration
- Secure WebDAV access
- SSH remote access
- Super Admin + Sub-Admin hierarchy
- YubiKey + 2FA support
- AI agent ready

## Quick Start
1. Connect clouds: `rclone config reconnect [remote]:`
2. Start services: `~/start_webdav.sh`
3. Access WebUI: http://localhost:5244

## Security
- SSH Ed25519 keys
- Single connection limit
- Localhost-only services
- Audit logging

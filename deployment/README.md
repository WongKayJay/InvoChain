# InvoChain Deployment Files

This folder contains all deployment-related files for the InvoChain project.

## 📁 Folder Contents

### 🚀 Deployment Scripts
- **deploy-g1t2.bat** - PRIMARY deployment script for g1t2.drshaiban.cloud (Windows)
- **deploy.sh** - Deployment script for Linux/Mac
- **server-setup.sh** - Initial server setup script (Ubuntu/Debian)
- **backup.sh** - Backup script for deployed files

### 📋 Deployment Guides
- **DEPLOY-G1T2.md** - PRIMARY comprehensive deployment guide (500+ lines)
- **HOSTINGER.md** - Hostinger-specific deployment guide
- **DEPLOYMENT-CHECKLIST-G1T2.md** - PRIMARY step-by-step checklist
- **DEPLOYMENT-READY.md** - Deployment readiness verification
- **DEPLOYMENT-STATUS.md** - Current deployment configuration summary

### ⚙️ Server Configuration
- **nginx-g1t2.conf** - PRIMARY Nginx configuration for g1t2.drshaiban.cloud

## 🎯 Current Deployment Target

**Production Domains:**
- Main Website: https://g1t2.drshaiban.cloud
- Web Application: https://app.g1t2.drshaiban.cloud
- Backend API: https://g1t2.drshaiban.cloud/api

## 🚀 Quick Deployment

### Windows (Recommended)
```powershell
.\deployment\deploy-g1t2.bat all
```

### Linux/Mac
```bash
./deployment/deploy.sh
```

## 📖 Documentation Order

If you're deploying for the first time, follow this order:

1. **Read**: `DEPLOY-G1T2.md` - Comprehensive guide with all details
2. **Follow**: `DEPLOYMENT-CHECKLIST-G1T2.md` - Step-by-step checklist
3. **Run**: `deploy-g1t2.bat all` - Execute deployment
4. **Verify**: `DEPLOYMENT-READY.md` - Check deployment status

## 📝 DNS Configuration

Before deploying, configure DNS in Hostinger:
- A record: `g1t2` → [Your Server IP]
- A record: `app.g1t2` → [Your Server IP]

Wait 10-15 minutes for DNS propagation, then deploy.

## 🔧 Server Requirements

- Ubuntu 20.04/22.04 LTS
- Nginx web server
- Node.js v20+
- PM2 process manager
- Certbot for SSL certificates

## 📞 Support

For detailed instructions, see:
- `DEPLOY-G1T2.md` - Full deployment guide
- `DEPLOYMENT-CHECKLIST-G1T2.md` - Quick checklist
- `HOSTINGER.md` - DNS configuration help

---

**Note**: All deployment files are consolidated in this folder for easy access and organization.

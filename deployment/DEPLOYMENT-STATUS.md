# InvoChain Deployment Configuration Summary

**Last Updated**: October 29, 2025  
**Current Deployment Target**: g1t2.drshaiban.cloud

## 🌐 Domain Configuration

### Production Domains
- **Main Website**: https://g1t2.drshaiban.cloud
- **Web Application**: https://app.g1t2.drshaiban.cloud
- **Backend API**: https://g1t2.drshaiban.cloud/api

### DNS Records Required (Hostinger)
```
Type: A    Name: g1t2        Points to: [Your Server IP]
Type: A    Name: app.g1t2    Points to: [Your Server IP]
```

## 📁 Updated Files

All deployment configurations have been updated to use the new domain structure:

### Deployment Scripts
- ✅ `deployment/deploy-g1t2.bat` - **PRIMARY DEPLOYMENT SCRIPT**
- ✅ `deployment/deploy.sh` - Linux/Mac deployment script

### Configuration Files
- ✅ `deployment/nginx-g1t2.conf` - **CURRENT NGINX CONFIG**
  - Website: g1t2.drshaiban.cloud
  - App: app.g1t2.drshaiban.cloud
  - Separate SSL certificates for each domain

### Documentation
- ✅ `deployment/DEPLOY-G1T2.md` - **CURRENT DEPLOYMENT GUIDE**
- ✅ `deployment/DEPLOYMENT-CHECKLIST-G1T2.md` - **CURRENT CHECKLIST**
- ✅ `COMMANDS.md` - Updated deployment commands
- ✅ `README.md` - Updated live demo link

### Website Files
- ✅ `frontend/website/index.html` - Web app link points to app.g1t2.drshaiban.cloud
- ✅ `frontend/website/downloads/InvoChain-Mobile-Installer.html` - Updated app link
- ✅ `frontend/website/downloads/InvoChain-Desktop-Installer.html` - Updated app link

## 🚀 Quick Deployment Guide

### Prerequisites
1. Configure DNS in Hostinger:
   - Add A record: `g1t2` → [Server IP]
   - Add A record: `app.g1t2` → [Server IP]
   - Wait 10-15 minutes for propagation

2. Verify DNS:
   ```powershell
   nslookup g1t2.drshaiban.cloud
   nslookup app.g1t2.drshaiban.cloud
   ```

### Deploy Everything
```powershell
cd C:\Users\there\Downloads\InvoChain
.\deployment\deploy-g1t2.bat all
```

### Deploy Individual Components
```powershell
.\deployment\deploy-g1t2.bat website   # Marketing website only
.\deployment\deploy-g1t2.bat app       # Flutter app only
.\deployment\deploy-g1t2.bat backend   # Backend API only
```

### Setup SSL Certificates
```bash
# SSH to server
ssh root@drshaiban.cloud

# Setup certificates for both domains
certbot --nginx -d g1t2.drshaiban.cloud
certbot --nginx -d app.g1t2.drshaiban.cloud
```

## 📊 Server Directory Structure

```
/var/www/invochain-g1t2/
├── website/          → Serves: g1t2.drshaiban.cloud
├── app/              → Serves: app.g1t2.drshaiban.cloud
└── backend/          → API on both domains at /api
```

## ✅ Verification

After deployment, verify:

```powershell
# Website
Invoke-WebRequest -Uri "https://g1t2.drshaiban.cloud" | Select-Object StatusCode

# App
Invoke-WebRequest -Uri "https://app.g1t2.drshaiban.cloud" | Select-Object StatusCode

# API
Invoke-RestMethod -Uri "https://g1t2.drshaiban.cloud/api/health"
```

Expected:
- Website returns 200 OK
- App returns 200 OK
- API returns `{"status":"OK",...}`

## 🔄 Deployment Architecture

### Current Configuration: g1t2.drshaiban.cloud
- Main website at g1t2.drshaiban.cloud
- App on separate subdomain: app.g1t2.drshaiban.cloud
- Separate SSL certificates required for each domain
- Nginx configuration with two server blocks

### Architecture Benefits
| Feature | Implementation | Benefit |
|---------|---------------|---------|
| Website | g1t2.drshaiban.cloud | Clean main domain |
| App | app.g1t2.drshaiban.cloud | Independent subdomain |
| API | g1t2.drshaiban.cloud/api | Accessible from both domains |
| SSL Certs | 2 certificates | Better security isolation |
| Nginx Blocks | 2 server blocks | Clear separation of concerns |

## 📝 File Status

All files are current and actively used for g1t2.drshaiban.cloud deployment.
- ❌ **Deprecated** - Should not be used

## 🎯 Next Steps

1. **Configure DNS** in Hostinger (both A records)
2. **Wait** 10-15 minutes for DNS propagation
3. **Run deployment**: `.\scripts\deploy-g1t2.bat all`
4. **Setup SSL**: Run certbot for both domains
5. **Test**: Visit both URLs and verify functionality

## 📞 Support

- **Deployment Guide**: `docs/DEPLOY-G1T2.md`
- **Checklist**: `DEPLOYMENT-CHECKLIST-G1T2.md`
- **Commands Reference**: `COMMANDS.md`
- **Project Structure**: `NAVIGATION.md`

---

*All configurations verified and updated for g1t2.drshaiban.cloud deployment.*

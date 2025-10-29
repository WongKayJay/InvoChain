# ✅ InvoChain Deployment Configuration - VERIFIED

**Status**: All configurations updated and verified  
**Date**: October 29, 2025  
**Deployment Target**: g1t2.drshaiban.cloud + app.g1t2.drshaiban.cloud

---

## 🎯 Current Deployment Setup

### Domain Configuration
| Service | Domain | Purpose |
|---------|--------|---------|
| Website | `https://g1t2.drshaiban.cloud` | Marketing landing page |
| Web App | `https://app.g1t2.drshaiban.cloud` | Flutter web application |
| Backend API | `https://g1t2.drshaiban.cloud/api` | REST API (accessible from both domains) |

### DNS Records (Hostinger)
```
Type: A    Name: g1t2        Value: [Your Server IP]    TTL: 14400
Type: A    Name: app.g1t2    Value: [Your Server IP]    TTL: 14400
```

---

## ✅ Verified Files

### Deployment Scripts
- ✅ `scripts/deploy-g1t2.bat` - **USE THIS for deployment**
- ✅ `scripts/deploy.bat` - Updated (legacy, redirects to deploy-g1t2.bat)
- ℹ️ `scripts/deploy-g2t1.bat` - Old version (kept for reference)

### Nginx Configuration
- ✅ `docs/nginx-g1t2.conf` - **USE THIS for server setup**
  - Two server blocks (website + app subdomain)
  - Separate SSL certificates
  - CORS properly configured
- ℹ️ `docs/nginx-g2t1.conf` - Old version (kept for reference)

### Documentation
- ✅ `docs/DEPLOY-G1T2.md` - Complete deployment guide (500+ lines)
- ✅ `DEPLOYMENT-CHECKLIST-G1T2.md` - Step-by-step checklist
- ✅ `DEPLOYMENT-CHECKLIST.md` - Updated with g1t2 domains
- ✅ `DEPLOYMENT-STATUS.md` - Configuration summary
- ✅ `COMMANDS.md` - Updated PowerShell commands reference
- ✅ `README.md` - Live demo link updated to g1t2

### Website Files
All "Launch Web App" buttons correctly point to `app.g1t2.drshaiban.cloud`:
- ✅ `frontend/website/index.html` (main homepage)
- ✅ `frontend/website/downloads/InvoChain-Mobile-Installer.html`
- ✅ `frontend/website/downloads/InvoChain-Desktop-Installer.html`

---

## 🚀 Quick Deployment

### 1. Prerequisites Check
```powershell
# Check files exist
Test-Path scripts\deploy-g1t2.bat
Test-Path docs\nginx-g1t2.conf
Test-Path frontend\website\index.html
Test-Path frontend\mobile-app\build\web
```

### 2. Deploy Everything
```powershell
cd C:\Users\there\Downloads\InvoChain
.\scripts\deploy-g1t2.bat all
```

### 3. Setup SSL (on server)
```bash
ssh root@drshaiban.cloud
certbot --nginx -d g1t2.drshaiban.cloud
certbot --nginx -d app.g1t2.drshaiban.cloud
```

---

## 📋 Verification Checklist

### Pre-Deployment
- [ ] DNS A records added in Hostinger (g1t2 and app.g1t2)
- [ ] DNS propagated (10-15 minutes wait)
- [ ] Server accessible via SSH
- [ ] Local builds completed:
  - [ ] Website: `npm run build` in `frontend/website/`
  - [ ] Flutter: `flutter build web` in `frontend/mobile-app/`

### Post-Deployment
- [ ] Website loads: https://g1t2.drshaiban.cloud
- [ ] App loads: https://app.g1t2.drshaiban.cloud
- [ ] API responds: https://g1t2.drshaiban.cloud/api/health
- [ ] SSL certificates valid (green padlock)
- [ ] "Launch Web App" button on website works
- [ ] No CORS errors in browser console

---

## 🔍 Configuration Summary

### Website (g1t2.drshaiban.cloud)
```nginx
server {
    listen 443 ssl http2;
    server_name g1t2.drshaiban.cloud;
    root /var/www/invochain-g1t2/website;
    
    # Main marketing site
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # API proxy
    location /api {
        proxy_pass http://localhost:3000;
    }
}
```

### App Subdomain (app.g1t2.drshaiban.cloud)
```nginx
server {
    listen 443 ssl http2;
    server_name app.g1t2.drshaiban.cloud;
    root /var/www/invochain-g1t2/app;
    
    # Flutter web app
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # API proxy (same backend)
    location /api {
        proxy_pass http://localhost:3000;
    }
}
```

### Backend (Node.js on port 3000)
```bash
# Managed by PM2
pm2 start server.js --name invochain-api
pm2 save
pm2 startup
```

---

## 📊 Server Directory Structure

```
/var/www/invochain-g1t2/
├── website/                    # Marketing site
│   ├── index.html
│   ├── assets/
│   └── downloads/
│
├── app/                        # Flutter web app
│   ├── index.html
│   ├── flutter.js
│   ├── main.dart.js
│   └── assets/
│
└── backend/                    # Node.js API
    ├── server.js
    ├── routes/
    ├── models/
    └── database/
        └── invochain.db
```

---

## 🎯 Key Changes from Previous Setup

### Domain Structure
- **Old**: g2t1.drshaiban.cloud with `/app` path
- **New**: Separate subdomain app.g1t2.drshaiban.cloud

### Benefits
✅ Cleaner URLs (no `/app` path)  
✅ Independent SSL certificates  
✅ Better SEO (separate domains)  
✅ Easier CORS configuration  
✅ Scalability (can move app to different server later)

### Migration Notes
- Requires 2 DNS A records instead of 1
- Requires 2 SSL certificates instead of 1
- Nginx has 2 server blocks instead of 1
- Website links updated to point to new app subdomain

---

## ✅ All Systems Ready

**Deployment Configuration**: ✅ Complete  
**Documentation**: ✅ Up to date  
**Website Links**: ✅ Pointing to app.g1t2.drshaiban.cloud  
**Scripts**: ✅ Using correct paths and domains  
**Nginx Config**: ✅ Configured for both domains  

---

## 📞 Next Steps

1. **Configure DNS** in Hostinger (2 A records)
2. **Wait** 10-15 minutes
3. **Verify DNS**: `nslookup g1t2.drshaiban.cloud` and `nslookup app.g1t2.drshaiban.cloud`
4. **Deploy**: Run `.\scripts\deploy-g1t2.bat all`
5. **SSL**: Run certbot for both domains
6. **Test**: Visit both URLs and verify

---

## 📚 Documentation Reference

- **Full Guide**: `docs/DEPLOY-G1T2.md`
- **Checklist**: `DEPLOYMENT-CHECKLIST-G1T2.md`
- **Commands**: `COMMANDS.md`
- **Status**: `DEPLOYMENT-STATUS.md` (this file)

---

*Everything is configured correctly and ready for deployment to g1t2.drshaiban.cloud!*

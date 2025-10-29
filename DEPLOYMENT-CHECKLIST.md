# 🚀 InvoChain Deployment Checklist

> **Note**: This file has been updated for the new deployment domain.
> For detailed step-by-step instructions, see `DEPLOYMENT-CHECKLIST-G1T2.md`

## Current Deployment Target

- **Main Website**: https://g1t2.drshaiban.cloud
- **Web App**: https://app.g1t2.drshaiban.cloud  
- **Backend API**: https://g1t2.drshaiban.cloud/api

## Quick Deployment

```powershell
# Deploy everything
.\scripts\deploy-g1t2.bat all
```

## Pre-Deployment Checklist

- [ ] Marketing website built (`frontend\website\dist\`)
- [ ] Flutter app built (`frontend\mobile-app\build\web\`)  
- [ ] Backend prepared (`backend\`)
- [ ] Deployment script ready (`scripts\deploy-g1t2.bat`)
- [ ] Nginx config ready (`docs\nginx-g1t2.conf`)
- [ ] DNS configured in Hostinger:
  - [ ] A record: `g1t2` → [Server IP]
  - [ ] A record: `app.g1t2` → [Server IP]

---

## 🌐 DNS Configuration (REQUIRED - DO THIS FIRST!)

### Hostinger DNS Setup

1. **Login to Hostinger**
   - Go to: https://www.hostinger.com
   - Login with your credentials
   - Navigate to **Domains**

2. **Select Domain**
   - Find: `drshaiban.cloud`
   - Click **Manage** or **DNS Zone**

3. **Add A Records**
   ```
   Type:      A
   Name:      g1t2
   Points to: [GET YOUR SERVER IP FROM: ssh root@drshaiban.cloud then run: curl ifconfig.me]
   TTL:       14400 (default)
   
   Type:      A
   Name:      app.g1t2
   Points to: [SAME SERVER IP]
   TTL:       14400 (default)
   ```

4. **Save and Wait**
   - Click **Save** or **Add Record**
   - Wait 10-15 minutes for DNS propagation

5. **Verify DNS**
   ```powershell
   nslookup g1t2.drshaiban.cloud
   nslookup app.g1t2.drshaiban.cloud
   ```
   Both should return your server IP

---

## 🖥️ Server Preparation (DO THIS SECOND!)

### Connect to Server
```bash
ssh root@drshaiban.cloud
```

### Install Software (if not already installed)
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2 (process manager)
sudo npm install -g pm2

# Install Certbot (for SSL)
sudo apt install certbot python3-certbot-nginx -y

# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable
```

### Create Directories
```bash
# Create deployment directories
sudo mkdir -p /var/www/invochain-g2t1/{website,app,backend}

# Set ownership
sudo chown -R $USER:$USER /var/www/invochain-g2t1

# Set permissions
sudo chmod -R 755 /var/www/invochain-g2t1

# Verify
ls -la /var/www/
```

---

## 🚀 Deployment (DO THIS THIRD!)

### Option A: Automated Deployment (Recommended)

On your **Windows machine**:

```powershell
# Navigate to project
cd C:\Users\there\Downloads\InvoChain

# Deploy everything
.\scripts\deploy-g2t1.bat all
```

The script will:
- Build and upload website
- Upload Flutter app  
- Upload and start backend API
- Configure Nginx
- Setup SSL certificate

---

### Option B: Manual Deployment

#### 1. Deploy Website
```powershell
# On Windows
cd frontend\website
npm run build
scp -r dist\* root@drshaiban.cloud:/var/www/invochain-g2t1/website/
```

#### 2. Deploy Flutter App
```powershell
# On Windows
cd frontend\mobile-app
flutter build web --release
scp -r build\web\* root@drshaiban.cloud:/var/www/invochain-g2t1/app/
```

#### 3. Deploy Backend
```powershell
# On Windows
scp -r backend\* root@drshaiban.cloud:/var/www/invochain-g1t2/backend/

# On Server
ssh root@drshaiban.cloud
cd /var/www/invochain-g1t2/backend
npm install --production
pm2 start server.js --name invochain-api
pm2 save
pm2 startup
```

#### 4. Configure Nginx
```powershell
# On Windows - upload config
scp docs\nginx-g1t2.conf root@drshaiban.cloud:/etc/nginx/sites-available/invochain-g1t2

# On Server
ssh root@drshaiban.cloud
sudo ln -s /etc/nginx/sites-available/invochain-g1t2 /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### 5. Setup SSL
```bash
# On Server
sudo certbot --nginx -d g1t2.drshaiban.cloud
sudo certbot --nginx -d app.g1t2.drshaiban.cloud
# Follow prompts, choose option 2 to redirect HTTP to HTTPS
```

---

## ✅ Verification (DO THIS LAST!)

### 1. Check Services
```bash
# On Server
sudo systemctl status nginx
pm2 status
pm2 logs invochain-api
```

### 2. Test URLs
```powershell
# On Windows
Invoke-WebRequest -Uri "https://g1t2.drshaiban.cloud" | Select-Object StatusCode
Invoke-WebRequest -Uri "https://app.g1t2.drshaiban.cloud" | Select-Object StatusCode
Invoke-RestMethod -Uri "https://g1t2.drshaiban.cloud/api/health"
```

### 3. Browser Test
Open in browser:
- **Website**: https://g1t2.drshaiban.cloud
- **Flutter App**: https://app.g1t2.drshaiban.cloud
- **API Health**: https://g1t2.drshaiban.cloud/api/health

---

## 🎯 QUICK START - Complete Deployment in 5 Steps

1. **DNS**: Add `g1t2` and `app.g1t2` A records in Hostinger pointing to your server IP
2. **Wait**: 10-15 minutes for DNS to propagate
3. **Prepare**: SSH to server and run the "Server Preparation" commands above
4. **Deploy**: Run `.\scripts\deploy-g1t2.bat all` on Windows
5. **Test**: Visit https://g1t2.drshaiban.cloud

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| DNS not resolving | Wait 15-30 mins, check with `nslookup g1t2.drshaiban.cloud` |
| Connection refused | Check firewall: `sudo ufw status` |
| Nginx not starting | Check logs: `sudo tail -f /var/log/nginx/error.log` |
| Backend not running | Check PM2: `pm2 logs invochain-api` |
| SSL fails | Ensure DNS works first, then retry certbot |
| 502 Bad Gateway | Backend not running, check: `pm2 status` |

---

## 📞 Need Help?

1. **Check detailed guide**: `docs\DEPLOY-G1T2.md`
2. **View logs**: 
   - Nginx: `/var/log/nginx/invochain-g1t2-*.log`
   - Backend: `pm2 logs invochain-api`
3. **Test DNS**: https://dnschecker.org

---

## 🎉 Success Criteria

✅ Website loads at https://g1t2.drshaiban.cloud  
✅ Flutter app loads at https://app.g1t2.drshaiban.cloud  
✅ API responds at https://g1t2.drshaiban.cloud/api/health  
✅ SSL certificates valid (green padlock in browser)  
✅ No console errors in browser  

---

*Ready to deploy? Start with DNS configuration in Hostinger!*

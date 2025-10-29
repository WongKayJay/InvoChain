# InvoChain Deployment to g2t1.drshaiban.cloud
## Step-by-Step Guide

This guide will help you deploy InvoChain to **g2t1.drshaiban.cloud** using Hostinger DNS and your existing server.

---

## 📋 Pre-Deployment Checklist

- [ ] SSH access to drshaiban.cloud server
- [ ] Hostinger account access for DNS management
- [ ] All services tested locally (backend, website, Flutter app)
- [ ] Git repository up to date

---

## 🌐 Step 1: Configure DNS in Hostinger

### 1.1 Log into Hostinger
1. Go to https://www.hostinger.com
2. Login with your credentials
3. Navigate to **Domains**

### 1.2 Add DNS Record
1. Select **drshaiban.cloud**
2. Click **DNS Zone** or **Manage DNS**
3. Click **Add Record**
4. Add this A record:

```
Type:      A
Name:      g2t1
Points to: [YOUR_SERVER_IP]  (get this from your server admin)
TTL:       14400 (or default)
```

5. Click **Save**

### 1.3 Verify DNS (wait 5-10 minutes)
```powershell
nslookup g2t1.drshaiban.cloud
```

---

## 🖥️ Step 2: Prepare Server

### 2.1 Connect to Server
```bash
ssh root@drshaiban.cloud
```

### 2.2 Install Required Software
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install Node.js (for backend)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2 (process manager for Node.js)
sudo npm install -g pm2

# Install Certbot (for SSL)
sudo apt install certbot python3-certbot-nginx -y

# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

### 2.3 Create Deployment Directory
```bash
sudo mkdir -p /var/www/invochain-g2t1/{website,app,backend}
sudo chown -R $USER:$USER /var/www/invochain-g2t1
sudo chmod -R 755 /var/www/invochain-g2t1
```

---

## 📦 Step 3: Build Locally (Windows)

### 3.1 Build Marketing Website
```powershell
cd frontend\website
npm install
npm run build
```

### 3.2 Build Flutter App
```powershell
cd frontend\mobile-app
flutter build web --release
```

### 3.3 Prepare Backend
Ensure `.env` file exists in `backend/` with:
```env
PORT=3000
NODE_ENV=production
JWT_SECRET=your_secure_secret_key_here
CORS_ORIGIN=https://g2t1.drshaiban.cloud
```

---

## 🚀 Step 4: Deploy Using Script

### Option A: Deploy Everything (Recommended)
```powershell
cd C:\Users\there\Downloads\InvoChain
.\scripts\deploy-g2t1.bat all
```

### Option B: Deploy Individual Components
```powershell
# Deploy website only
.\scripts\deploy-g2t1.bat website

# Deploy Flutter app only
.\scripts\deploy-g2t1.bat app

# Deploy backend only
.\scripts\deploy-g2t1.bat backend
```

---

## ⚙️ Step 5: Configure Nginx on Server

### 5.1 Create Nginx Configuration
On your local machine, the script will copy `docs/nginx-g2t1.conf` to the server.

Alternatively, manually on the server:
```bash
sudo nano /etc/nginx/sites-available/invochain-g2t1
```

Paste the content from `docs/nginx-g2t1.conf`, then:

```bash
# Enable the site
sudo ln -s /etc/nginx/sites-available/invochain-g2t1 /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

---

## 🔒 Step 6: Setup SSL Certificate

```bash
# Request certificate from Let's Encrypt
sudo certbot --nginx -d g2t1.drshaiban.cloud

# Follow prompts:
# - Enter email: your-email@example.com
# - Agree to Terms: Yes
# - Share email: No
# - Redirect HTTP to HTTPS: 2 (recommended)

# Verify auto-renewal
sudo certbot renew --dry-run
```

---

## ✅ Step 7: Verify Deployment

### 7.1 Check Services
```bash
# Check Nginx status
sudo systemctl status nginx

# Check backend API
pm2 status

# Check backend logs
pm2 logs invochain-g2t1-api
```

### 7.2 Test URLs
- **Website**: https://g2t1.drshaiban.cloud
- **Flutter App**: https://g2t1.drshaiban.cloud/app
- **API Health**: https://g2t1.drshaiban.cloud/api/health

### 7.3 Test from Windows
```powershell
# Test website
Invoke-WebRequest -Uri "https://g2t1.drshaiban.cloud" | Select-Object StatusCode

# Test Flutter app
Invoke-WebRequest -Uri "https://g2t1.drshaiban.cloud/app" | Select-Object StatusCode

# Test API
Invoke-RestMethod -Uri "https://g2t1.drshaiban.cloud/api/health"
```

---

## 🔧 Troubleshooting

### DNS Not Resolving
```powershell
# Check DNS propagation
nslookup g2t1.drshaiban.cloud

# Online checker
# Visit: https://dnschecker.org
```
**Solution**: Wait 15-30 minutes for DNS propagation

### Nginx Not Starting
```bash
# Check error logs
sudo tail -f /var/log/nginx/error.log

# Test configuration
sudo nginx -t
```

### Backend Not Running
```bash
# Check PM2 status
pm2 status

# Restart backend
pm2 restart invochain-g2t1-api

# Check logs
pm2 logs invochain-g2t1-api --lines 50
```

### SSL Certificate Issues
```bash
# Check certificate status
sudo certbot certificates

# Renew manually
sudo certbot renew --force-renewal
```

### Permission Issues
```bash
# Fix ownership
sudo chown -R www-data:www-data /var/www/invochain-g2t1

# Fix permissions
sudo chmod -R 755 /var/www/invochain-g2t1
```

---

## 🔄 Updating Deployment

### Update Website
```powershell
cd frontend\website
npm run build
.\scripts\deploy-g2t1.bat website
```

### Update Flutter App
```powershell
cd frontend\mobile-app
flutter build web --release
.\scripts\deploy-g2t1.bat app
```

### Update Backend
```powershell
.\scripts\deploy-g2t1.bat backend
```

---

## 📊 Monitoring

### Check Access Logs
```bash
sudo tail -f /var/log/nginx/invochain-g2t1-access.log
```

### Check Error Logs
```bash
sudo tail -f /var/log/nginx/invochain-g2t1-error.log
```

### Monitor Backend
```bash
pm2 monit
```

---

## 🎯 Quick Reference

| Component | URL | Directory |
|-----------|-----|-----------|
| Website | https://g2t1.drshaiban.cloud | /var/www/invochain-g2t1/website |
| Flutter App | https://g2t1.drshaiban.cloud/app | /var/www/invochain-g2t1/app |
| Backend API | https://g2t1.drshaiban.cloud/api | /var/www/invochain-g2t1/backend |

### Important Commands
```bash
# Restart Nginx
sudo systemctl restart nginx

# Restart Backend
pm2 restart invochain-g2t1-api

# Check all services
sudo systemctl status nginx && pm2 status

# View all logs
sudo tail -f /var/log/nginx/*.log
pm2 logs
```

---

## 📞 Support

If you encounter issues:
1. Check logs: Nginx logs and PM2 logs
2. Verify DNS: `nslookup g2t1.drshaiban.cloud`
3. Test locally: Ensure everything works on localhost first
4. Check firewall: `sudo ufw status`

---

*Last Updated: October 29, 2025*
*Deployment Target: g2t1.drshaiban.cloud*

# InvoChain Quick Start Deployment Guide
## Deploy to g1t2.drshaiban.cloud in 15 Minutes

This quick start guide will get InvoChain up and running on your server.

---

## 🚀 Prerequisites

- Server access to `drshaiban.cloud`
- SSH key configured
- Domain DNS managed via Hostinger

---

## ⚡ Quick Deploy (5 Steps)

### Step 1: Configure DNS in Hostinger

1. Log into Hostinger
2. Go to Domain → DNS Records
3. Add A record:
   ```
   Type: A
   Name: g1t2
   Points to: [YOUR_SERVER_IP]
   TTL: 14400
   ```

### Step 2: Server Initial Setup

```bash
# Connect to server
ssh root@drshaiban.cloud

# Run setup script
curl -fsSL https://raw.githubusercontent.com/WongKayJay/InvoChain/main/deployment/server-setup.sh | bash

# Or manual setup:
sudo apt update && sudo apt upgrade -y
sudo apt install nginx certbot python3-certbot-nginx git -y
sudo mkdir -p /var/www/invochain/{website,app}
```

### Step 3: Build Flutter App Locally

```powershell
# On your Windows machine
cd c:\Users\there\Downloads\InvoChain\Application\invochain_app

# Build for production
flutter clean
flutter pub get
flutter build web --release --web-renderer html
```

### Step 4: Deploy to Server

```powershell
# Using provided deployment script
cd c:\Users\there\Downloads\InvoChain
.\deployment\deploy.bat all

# Or manual deployment:
scp -r Website\* root@drshaiban.cloud:/var/www/invochain/website/
scp -r Application\invochain_app\build\web\* root@drshaiban.cloud:/var/www/invochain/app/
```

### Step 5: Configure Nginx & SSL

```bash
# On server
cd /var/www/invochain

# Clone repo for config files
git clone https://github.com/WongKayJay/InvoChain.git temp
sudo cp temp/deployment/nginx.conf /etc/nginx/sites-available/invochain
rm -rf temp

# Enable site
sudo ln -s /etc/nginx/sites-available/invochain /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Get SSL certificate
sudo certbot --nginx -d g1t2.drshaiban.cloud

# Follow prompts and select redirect HTTP to HTTPS
```

---

## ✅ Verification

Open in browser:
- **Website**: https://g1t2.drshaiban.cloud
- **Flutter App**: https://g1t2.drshaiban.cloud/app

---

## 🔄 Updates

### Update Website
```bash
ssh root@drshaiban.cloud
cd /var/www/invochain/InvoChain
git pull origin main
cp -r Website/* /var/www/invochain/website/
sudo systemctl reload nginx
```

### Update Flutter App
```powershell
# Local machine
cd Application\invochain_app
flutter build web --release
scp -r build\web\* root@drshaiban.cloud:/var/www/invochain/app/
```

---

## 🐛 Troubleshooting

**Site not loading?**
```bash
# Check Nginx
sudo systemctl status nginx
sudo nginx -t

# Check logs
sudo tail -f /var/log/nginx/error.log
```

**SSL not working?**
```bash
# Verify certificate
sudo certbot certificates

# Renew if needed
sudo certbot renew
```

**Flutter app blank screen?**
- Check browser console (F12)
- Verify files exist: `ls -la /var/www/invochain/app/`
- Check file permissions: `chmod -R 755 /var/www/invochain/app/`

---

## 📞 Need Help?

- Full guide: See `DEPLOYMENT.md`
- GitHub: https://github.com/WongKayJay/InvoChain
- Issues: Open an issue on GitHub

---

**Deployment Time**: ~15 minutes  
**Difficulty**: Beginner-Friendly  
**Requirements**: SSH access + Hostinger DNS

# InvoChain Deployment Guide
## Hosting on g1t2.drshaiban.cloud

This guide provides step-by-step instructions for deploying the InvoChain website and Flutter web application to your high-capacity server at `drshaiban.cloud` using the subdomain `g1t2.drshaiban.cloud`.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Server Setup](#server-setup)
3. [DNS Configuration (Hostinger)](#dns-configuration)
4. [Build Flutter Web App](#build-flutter-web-app)
5. [Deploy to Server](#deploy-to-server)
6. [Configure Nginx](#configure-nginx)
7. [SSL Certificate Setup](#ssl-certificate)
8. [Testing & Verification](#testing)
9. [Maintenance](#maintenance)

---

## 🔧 Prerequisites

Before deploying, ensure you have:

- ✅ SSH access to `drshaiban.cloud` server
- ✅ Root or sudo privileges on the server
- ✅ Domain DNS management access (via Hostinger)
- ✅ Flutter SDK installed locally (for building)
- ✅ Git installed on both local and server

### Server Requirements

- **OS**: Ubuntu 20.04+ / Debian 11+ (recommended)
- **RAM**: 2GB minimum (4GB+ recommended)
- **Storage**: 10GB+ available
- **Software**: Nginx, Git, Certbot (for SSL)

---

## 🖥️ Server Setup

### Step 1: Connect to Your Server

```bash
ssh root@drshaiban.cloud
# Or use your configured username
ssh your_username@drshaiban.cloud
```

### Step 2: Update Server & Install Dependencies

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install Nginx web server
sudo apt install nginx -y

# Install Git
sudo apt install git -y

# Install Certbot for SSL certificates
sudo apt install certbot python3-certbot-nginx -y

# Install Node.js (optional, for future enhancements)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### Step 3: Configure Firewall

```bash
# Allow SSH
sudo ufw allow OpenSSH

# Allow HTTP and HTTPS
sudo ufw allow 'Nginx Full'

# Enable firewall
sudo ufw enable
```

### Step 4: Create Deployment Directory

```bash
# Create directory for InvoChain
sudo mkdir -p /var/www/invochain
sudo mkdir -p /var/www/invochain/website
sudo mkdir -p /var/www/invochain/app

# Set permissions
sudo chown -R $USER:$USER /var/www/invochain
sudo chmod -R 755 /var/www/invochain
```

---

## 🌐 DNS Configuration (Hostinger)

### Configure Subdomain in Hostinger

1. **Log into Hostinger Control Panel**
   - Go to https://www.hostinger.com
   - Navigate to your domain management

2. **Add DNS Record for g1t2.drshaiban.cloud**
   - Go to Domain → DNS/Nameservers → Manage DNS Records
   - Add the following A record:

   ```
   Type: A
   Name: g1t2
   Points to: YOUR_SERVER_IP (drshaiban.cloud IP)
   TTL: 14400 (or default)
   ```

3. **Verify DNS Propagation**
   ```bash
   # On your local machine
   nslookup g1t2.drshaiban.cloud
   # Should return your server IP
   ```

   Or use online tools:
   - https://dnschecker.org
   - https://www.whatsmydns.net

**Note**: DNS propagation can take 1-48 hours, but usually completes within 15-30 minutes.

---

## 🏗️ Build Flutter Web App

### Step 1: Navigate to Flutter Project

```bash
cd c:\Users\there\Downloads\InvoChain\Application\invochain_app
```

### Step 2: Build for Production

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for web (production)
flutter build web --release --web-renderer html

# Or for better performance with CanvasKit:
# flutter build web --release --web-renderer canvaskit
```

The build output will be in:
```
Application/invochain_app/build/web/
```

### Step 3: Optimize Build (Optional)

```bash
# Compress assets
cd build/web
# You can use gzip to pre-compress files
find . -type f \( -name '*.js' -o -name '*.css' -o -name '*.html' \) -exec gzip -k {} \;
```

---

## 📤 Deploy to Server

### Method 1: Using Git (Recommended)

```bash
# On server
cd /var/www/invochain

# Clone repository
git clone https://github.com/WongKayJay/InvoChain.git
cd InvoChain

# Copy website files
cp -r Website/* /var/www/invochain/website/

# Copy Flutter build (you'll need to build locally and push, or build on server)
# Option A: Copy from local after building
```

### Method 2: Using SCP (For Flutter Build)

```bash
# On your local machine (Windows PowerShell)
# Build first (see previous section)
cd c:\Users\there\Downloads\InvoChain\Application\invochain_app

# Copy Flutter web build to server
scp -r build\web\* root@drshaiban.cloud:/var/www/invochain/app/

# Copy website files
cd ..\..\..
scp -r Website\* root@drshaiban.cloud:/var/www/invochain/website/
```

### Method 3: Using rsync (Linux/Mac or WSL)

```bash
# More efficient for updates
rsync -avz --progress Application/invochain_app/build/web/ root@drshaiban.cloud:/var/www/invochain/app/
rsync -avz --progress Website/ root@drshaiban.cloud:/var/www/invochain/website/
```

---

## ⚙️ Configure Nginx

### Step 1: Create Nginx Configuration

```bash
# On server
sudo nano /etc/nginx/sites-available/invochain
```

Copy the configuration from `deployment/nginx.conf` (see separate file).

### Step 2: Enable Site

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/invochain /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### Step 3: Verify Nginx is Running

```bash
sudo systemctl status nginx

# If not running, start it
sudo systemctl start nginx

# Enable on boot
sudo systemctl enable nginx
```

---

## 🔒 SSL Certificate Setup

### Step 1: Obtain SSL Certificate with Certbot

```bash
# Obtain certificate for g1t2.drshaiban.cloud
sudo certbot --nginx -d g1t2.drshaiban.cloud

# Follow prompts:
# - Enter email for renewal notifications
# - Agree to terms of service
# - Choose whether to redirect HTTP to HTTPS (recommended: Yes)
```

### Step 2: Verify Auto-Renewal

```bash
# Test renewal process
sudo certbot renew --dry-run

# Certbot auto-renewal is set up via systemd timer
sudo systemctl status certbot.timer
```

### Step 3: Update Nginx Configuration (if needed)

Certbot should auto-configure SSL. Verify by checking:

```bash
sudo nano /etc/nginx/sites-available/invochain
```

You should see SSL certificate paths added automatically.

---

## ✅ Testing & Verification

### 1. Check Website Access

Open in browser:
- **Marketing Website**: https://g1t2.drshaiban.cloud
- **Flutter App**: https://g1t2.drshaiban.cloud/app

### 2. Test Download Buttons

- Click "Download for iOS/Android"
- Click "Download for Windows/Mac"
- Verify installer pages open correctly

### 3. Test Flutter App Features

- Login/Signup functionality
- Navigation between screens
- Investment tracking
- Invoice management
- Portfolio calculations

### 4. Verify SSL Certificate

```bash
# Check SSL grade
# Visit: https://www.ssllabs.com/ssltest/analyze.html?d=g1t2.drshaiban.cloud
```

### 5. Test Mobile Responsiveness

- Open on mobile devices
- Test all breakpoints
- Verify touch interactions

### 6. Performance Testing

```bash
# Use Google PageSpeed Insights
# https://pagespeed.web.dev/

# Or Lighthouse (in Chrome DevTools)
```

---

## 🔄 Maintenance & Updates

### Update Website Content

```bash
# On server
cd /var/www/invochain/InvoChain
git pull origin main
cp -r Website/* /var/www/invochain/website/
sudo systemctl reload nginx
```

### Update Flutter App

```bash
# On local machine - rebuild
cd Application/invochain_app
flutter build web --release

# Upload to server
scp -r build\web\* root@drshaiban.cloud:/var/www/invochain/app/
```

### Monitor Logs

```bash
# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# InvoChain specific logs
sudo tail -f /var/log/nginx/invochain.access.log
sudo tail -f /var/log/nginx/invochain.error.log
```

### Backup Strategy

```bash
# Create backup script
sudo nano /usr/local/bin/backup-invochain.sh
```

Add backup script (see `deployment/backup.sh`).

```bash
# Make executable
sudo chmod +x /usr/local/bin/backup-invochain.sh

# Add to crontab for daily backups
sudo crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-invochain.sh
```

---

## 🚀 Performance Optimization

### 1. Enable Gzip Compression

Already configured in nginx.conf, but verify:

```bash
sudo nano /etc/nginx/nginx.conf
```

Ensure this is in the `http` block:

```nginx
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
```

### 2. Configure Caching

Nginx configuration includes cache headers for static assets.

### 3. Setup CDN (Optional)

For global performance, consider:
- Cloudflare (free tier available)
- AWS CloudFront
- Fastly

### 4. Enable HTTP/2

Already enabled in nginx.conf with:
```nginx
listen 443 ssl http2;
```

---

## 🐛 Troubleshooting

### Issue: Site Not Accessible

```bash
# Check if Nginx is running
sudo systemctl status nginx

# Check configuration
sudo nginx -t

# Check firewall
sudo ufw status

# Check DNS
nslookup g1t2.drshaiban.cloud
```

### Issue: SSL Certificate Errors

```bash
# Check certificate status
sudo certbot certificates

# Renew if needed
sudo certbot renew --force-renewal
```

### Issue: Flutter App Not Loading

```bash
# Check file permissions
ls -la /var/www/invochain/app/

# Verify index.html exists
cat /var/www/invochain/app/index.html

# Check browser console for errors
```

### Issue: 502 Bad Gateway

```bash
# Check Nginx error logs
sudo tail -100 /var/log/nginx/error.log

# Verify upstream services (if using any)
```

---

## 📞 Support & Resources

- **InvoChain GitHub**: https://github.com/WongKayJay/InvoChain
- **Nginx Documentation**: https://nginx.org/en/docs/
- **Flutter Web Deployment**: https://docs.flutter.dev/deployment/web
- **Certbot Documentation**: https://certbot.eff.org/
- **Hostinger Support**: https://www.hostinger.com/support

---

## 📝 Quick Reference Commands

```bash
# Restart Nginx
sudo systemctl restart nginx

# Reload Nginx (no downtime)
sudo systemctl reload nginx

# Check Nginx status
sudo systemctl status nginx

# Test Nginx config
sudo nginx -t

# View access logs
sudo tail -f /var/log/nginx/access.log

# View error logs
sudo tail -f /var/log/nginx/error.log

# Renew SSL certificate
sudo certbot renew

# Pull latest changes
cd /var/www/invochain/InvoChain && git pull origin main
```

---

## 🎯 Deployment Checklist

- [ ] Server setup complete
- [ ] DNS configured in Hostinger
- [ ] Flutter web app built
- [ ] Files deployed to server
- [ ] Nginx configured
- [ ] SSL certificate installed
- [ ] Website accessible via HTTPS
- [ ] Flutter app accessible
- [ ] Download buttons working
- [ ] Mobile responsive
- [ ] Performance optimized
- [ ] Backups configured
- [ ] Monitoring setup

---

**Deployment Date**: October 28, 2025  
**Version**: 1.0.0  
**Deployed By**: InvoChain Team  
**Server**: g1t2.drshaiban.cloud

---

© 2025 InvoChain - Transparent, Secure Invoice Financing
